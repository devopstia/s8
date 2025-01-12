#!/bin/bash

# Set AWS CLI profile and region if required
AWS_PROFILE=default
AWS_REGION=us-east-1

# Get current date and time
CURRENT_DATE=$(date +"%Y-%m-%d-%H-%M-%S")

# Fetch instance IDs with the tag backup=true
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:backup,Values=true" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text \
  --profile $AWS_PROFILE \
  --region $AWS_REGION)

if [ -z "$INSTANCE_IDS" ]; then
  echo "No instances found with the tag backup=true."
  exit 1
fi

# Iterate over instance IDs and create AMIs
for INSTANCE_ID in $INSTANCE_IDS; do
  echo "Creating AMI for instance: $INSTANCE_ID"
  
  # Construct AMI name
  AMI_NAME="jenkins-backup-$CURRENT_DATE"

  # Create AMI
  AMI_ID=$(aws ec2 create-image \
    --instance-id $INSTANCE_ID \
    --name "$AMI_NAME" \
    --description "Backup AMI for $INSTANCE_ID created on $CURRENT_DATE" \
    --no-reboot \
    --query "ImageId" \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)

  if [ $? -eq 0 ]; then
    echo "AMI created successfully: $AMI_ID"

    # Add a tag to the AMI
    aws ec2 create-tags \
      --resources $AMI_ID \
      --tags Key=CreatedBy,Value=bash-shell-script \
      --profile $AWS_PROFILE \
      --region $AWS_REGION

    echo "Tag added to AMI: CreatedBy=bash-shell-script"
  else
    echo "Failed to create AMI for instance: $INSTANCE_ID"
  fi
done
