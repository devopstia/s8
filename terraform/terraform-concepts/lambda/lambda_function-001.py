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
    
    # Check if any instances were returned
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
                NoReboot=True,  # Change to False if you want to reboot the instance during backup
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
    
    return {
        'statusCode': 200,
        'body': 'AMI creation process completed successfully.'
    }
