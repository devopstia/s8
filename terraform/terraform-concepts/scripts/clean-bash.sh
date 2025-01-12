#!/bin/bash

AWS_REGION="us-east-1"
AWS_PROFILE="default"

# Function to fetch all AMIs with names starting with 'jenkins-backup'
fetch_amis() {
  aws ec2 describe-images \
    --owners self \
    --filters "Name=name,Values=jenkins-backup-*" \
    --query "Images[*].[ImageId,Name,CreationDate,BlockDeviceMappings]" \
    --output json \
    --region $AWS_REGION \
    --profile $AWS_PROFILE
}

# Function to delete old AMIs and their associated snapshots
delete_old_amis() {
  echo "Fetching AMIs with name starting with 'jenkins-backup'..."

  # Fetch AMIs
  AMIS=$(fetch_amis | tr -d '\r')

  if [ -z "$AMIS" ]; then
    echo "No AMIs found with name starting with 'jenkins-backup'."
    return
  fi

  # Sort AMIs by creation date in descending order
  SORTED_AMIS=$(echo "$AMIS" | jq -r '. | sort_by(.CreationDate) | reverse')

  # Keep the latest 4 AMIs
  AMIS_TO_DELETE=$(echo "$SORTED_AMIS" | jq -r '.[4:]')

  echo "$AMIS_TO_DELETE" | jq -c '.[]' | while read -r ami; do
    AMI_ID=$(echo "$ami" | jq -r '.[0]')
    AMI_NAME=$(echo "$ami" | jq -r '.[1]')
    SNAPSHOT_IDS=$(echo "$ami" | jq -r '.[3][]?.Ebs.SnapshotId')

    echo "Deregistering AMI: $AMI_NAME ($AMI_ID)"
    aws ec2 deregister-image --image-id "$AMI_ID" --region $AWS_REGION --profile $AWS_PROFILE

    # Delete associated snapshots
    for SNAPSHOT_ID in $SNAPSHOT_IDS; do
      echo "Deleting snapshot: $SNAPSHOT_ID"
      aws ec2 delete-snapshot --snapshot-id "$SNAPSHOT_ID" --region $AWS_REGION --profile $AWS_PROFILE
    done
  done
}

# Main script execution
delete_old_amis
