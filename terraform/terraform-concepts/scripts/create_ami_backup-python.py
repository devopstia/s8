import boto3
from datetime import datetime
import sys

# AWS configuration
AWS_REGION = "us-east-1"
AWS_PROFILE = "default"

def get_instances_with_backup_tag():
    """Fetch running instances with the tag backup=true."""
    session = boto3.Session(profile_name=AWS_PROFILE)
    ec2_client = session.client('ec2', region_name=AWS_REGION)

    response = ec2_client.describe_instances(
        Filters=[
            {'Name': 'tag:backup', 'Values': ['true']},
            {'Name': 'instance-state-name', 'Values': ['running']}
        ]
    )

    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances.append(instance['InstanceId'])

    return instances

def create_ami(instance_id):
    """Create an AMI for the given instance ID."""
    session = boto3.Session(profile_name=AWS_PROFILE)
    ec2_client = session.client('ec2', region_name=AWS_REGION)

    current_date = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    ami_name = f"jenkins-backup-{current_date}"

    print(f"Creating AMI for instance: {instance_id}")
    try:
        response = ec2_client.create_image(
            InstanceId=instance_id,
            Name=ami_name,
            Description=f"Backup AMI for {instance_id} created on {current_date}",
            NoReboot=True
        )

        ami_id = response['ImageId']
        print(f"AMI created successfully: {ami_id}")

        # Add tags to the AMI
        ec2_client.create_tags(
            Resources=[ami_id],
            Tags=[{'Key': 'CreatedBy', 'Value': 'python-script'}]
        )

        print(f"Tag added to AMI: CreatedBy=python-script")

    except Exception as e:
        print(f"Failed to create AMI for instance {instance_id}: {e}")

def main():
    """Main function."""
    instances = get_instances_with_backup_tag()

    if not instances:
        print("No instances found with the tag backup=true in a valid state.")
        sys.exit(1)

    for instance_id in instances:
        create_ami(instance_id)

if __name__ == "__main__":
    main()
