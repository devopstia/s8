import boto3
import datetime

def lambda_handler(event, context):
    # Create EC2 client
    ec2 = boto3.client('ec2')

    # Filter instances that have a tag 'backup' set to 'true'
    instances = ec2.describe_instances(
        Filters=[
            {'Name': 'tag:backup', 'Values': ['true']}
        ]
    )
    
    if not instances['Reservations']:
        print("No instances with tag 'backup=true' found.")
        return {
            'statusCode': 404,
            'body': 'No instances with tag backup=true found.'
        }

    # Current date and time, which will be used in the AMI name and tag
    creation_time = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    
    # Iterate through the reservations and instances
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            ami_name = f"s8-backup-{instance_id}-{creation_time}"
            
            # Create AMI from instance
            response = ec2.create_image(
                InstanceId=instance_id,
                Name=ami_name,
                Description=f"Backup of {instance_id}, created on {creation_time}",
                NoReboot=True,
                TagSpecifications=[
                    {
                        'ResourceType': 'image',
                        'Tags': [
                            {'Key': 'CreatedOn', 'Value': creation_time}
                        ]
                    }
                ]
            )
            print(f"AMI {response['ImageId']} created for instance {instance_id}")

    # Clean up old AMIs
    delete_old_amis(ec2)

    return {
        'statusCode': 200,
        'body': 'AMI creation and cleanup process completed successfully.'
    }

def delete_old_amis(ec2):
    # List all images with names starting with 's8-backup-'
    images = ec2.describe_images(Filters=[{'Name': 'name', 'Values': ['s8-backup-*']}])
    # Sort images by the creation date in descending order
    sorted_images = sorted(images['Images'], key=lambda x: x['CreationDate'], reverse=True)
    
    # Keep the 2 most recent images, deregister the rest
    for image in sorted_images[2:]:
        ec2.deregister_image(ImageId=image['ImageId'])
        print(f"Deregistered AMI {image['ImageId']} named {image['Name']}")

