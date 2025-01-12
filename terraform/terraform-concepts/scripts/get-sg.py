import boto3

# Initialize AWS session
session = boto3.Session()
ec2_client = session.client('ec2')
iam_client = session.client('iam')

def list_unused_security_groups():
    """List all unused security groups."""
    print("Fetching all security groups...")
    security_groups = ec2_client.describe_security_groups()['SecurityGroups']

    # Get all network interfaces
    network_interfaces = ec2_client.describe_network_interfaces()['NetworkInterfaces']

    # Extract security groups in use
    used_sg_ids = set(
        sg['GroupId']
        for ni in network_interfaces
        for sg in ni['Groups']
    )

    # Find unused security groups
    unused_sgs = [
        sg for sg in security_groups
        if sg['GroupId'] not in used_sg_ids and sg['GroupName'] != 'default'
    ]

    print("Unused Security Groups:")
    for sg in unused_sgs:
        print(f"- {sg['GroupId']} ({sg['GroupName']})")

    return unused_sgs

def list_unused_iam_policies():
    """List all unused IAM policies."""
    print("Fetching all IAM policies...")
    policies = iam_client.list_policies(Scope='Local')['Policies']

    # Find unused policies
    unused_policies = [
        policy for policy in policies
        if not policy['AttachmentCount']
    ]

    print("Unused IAM Policies:")
    for policy in unused_policies:
        print(f"- {policy['PolicyName']} ({policy['Arn']})")

    return unused_policies

def list_unused_iam_roles():
    """List all IAM roles that have not been used recently."""
    print("Fetching all IAM roles...")
    roles = iam_client.list_roles()['Roles']

    # Find roles that have never been used or have no recent activity
    unused_roles = []
    for role in roles:
        role_name = role['RoleName']
        role_details = iam_client.get_role(RoleName=role_name)
        last_used = role_details.get('RoleLastUsed', {}).get('LastUsedDate')

        if not last_used:
            unused_roles.append(role_name)

    print("Unused IAM Roles:")
    for role_name in unused_roles:
        print(f"- {role_name}")

    return unused_roles

def main():
    print("Listing unused AWS resources...")
    unused_sgs = list_unused_security_groups()
    unused_policies = list_unused_iam_policies()
    unused_roles = list_unused_iam_roles()

    print("\nSummary:")
    print(f"- Unused Security Groups: {len(unused_sgs)}")
    print(f"- Unused IAM Policies: {len(unused_policies)}")
    print(f"- Unused IAM Roles: {len(unused_roles)}")

if __name__ == "__main__":
    main()
