import boto3
from datetime import datetime

# AWS configuration
AWS_REGION = "us-east-1"
AWS_PROFILE = "default"

def delete_old_amis():
    """Delete old AMIs that start with 'jenkins-backup', keeping only the latest 4 and their associated snapshots."""
    session = boto3.Session(profile_name=AWS_PROFILE)
    ec2_client = session.client('ec2', region_name=AWS_REGION)

    print("Fetching AMIs with name starting with 'jenkins-backup'...")

    # Fetch all AMIs with names starting with 'jenkins-backup'
    response = ec2_client.describe_images(
        Owners=['self'],
        Filters=[
            {'Name': 'name', 'Values': ['jenkins-backup-*']}
        ]
    )

    amis = response['Images']

    if not amis:
        print("No AMIs found with name starting with 'jenkins-backup'.")
        return

    # Sort AMIs by creation date, descending
    amis.sort(key=lambda x: x['CreationDate'], reverse=True)

    # Keep the latest 4 AMIs, delete the rest
    amis_to_delete = amis[4:]

    for ami in amis_to_delete:
        ami_id = ami['ImageId']
        ami_name = ami['Name']

        # Fetch associated snapshots
        snapshot_ids = [bdm['Ebs']['SnapshotId'] for bdm in ami['BlockDeviceMappings'] if 'Ebs' in bdm]

        print(f"Deregistering AMI: {ami_name} ({ami_id})")
        try:
            ec2_client.deregister_image(ImageId=ami_id)
            print(f"Successfully deregistered AMI: {ami_name} ({ami_id})")

            # Delete associated snapshots
            for snapshot_id in snapshot_ids:
                print(f"Deleting snapshot: {snapshot_id}")
                try:
                    ec2_client.delete_snapshot(SnapshotId=snapshot_id)
                    print(f"Successfully deleted snapshot: {snapshot_id}")
                except Exception as e:
                    print(f"Failed to delete snapshot {snapshot_id}: {e}")

        except Exception as e:
            print(f"Failed to deregister AMI {ami_name} ({ami_id}): {e}")

def main():
    """Main function."""
    delete_old_amis()

if __name__ == "__main__":
    main()
