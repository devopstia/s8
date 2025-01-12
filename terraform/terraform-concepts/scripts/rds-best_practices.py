import boto3
from datetime import datetime, timezone

# Initialize AWS clients
rds_client = boto3.client("rds")
ec2_client = boto3.client("ec2")
cloudwatch_client = boto3.client("cloudwatch")

# List of Checks
CHECKS = [
    "Encryption",              # Ensure RDS instance is encrypted
    "Public Accessibility",    # Verify the instance is not publicly accessible
    "Automated Backups",       # Ensure backups are enabled
    "Multi-AZ Deployment",     # Check if deployed in Multi-AZ
    "Instance Type",           # Assess instance type suitability
    "Idle Instance",           # Identify idle instances with low CPU utilization
    "Security Group Rules",    # Ensure restricted access in security groups
    "Storage Type",            # Validate storage type optimization
    "Database Engine Version", # Ensure the database engine is up-to-date
    "Enhanced Monitoring",     # Check if Enhanced Monitoring is enabled
    "Performance Insights",    # Verify Performance Insights is enabled
    "Backup Retention Period", # Validate backup retention settings
    "Maintenance Window",      # Check if maintenance window is configured
    "IAM Authentication",      # Verify IAM DB authentication is enabled
    "Public Snapshot Sharing", # Ensure no RDS snapshots are shared publicly
    "Deletion Protection"      # Ensure deletion protection is enabled
]


def log_info(message):
    """Log informational messages."""
    print(f"[INFO] {message}")


def log_warning(message):
    """Log warning messages."""
    print(f"[WARNING] {message}")


def separator():
    """Print a separator for better readability."""
    print("-" * 80)


# Check Functions
def check_rds_encryption(db_instance):
    return "Encrypted" if db_instance.get("StorageEncrypted") else "Not Encrypted"


def check_public_accessibility(db_instance):
    return "Publicly Accessible" if db_instance.get("PubliclyAccessible") else "Not Publicly Accessible"


def check_automated_backups(db_instance):
    return "Backups Enabled" if db_instance.get("BackupRetentionPeriod", 0) > 0 else "Backups Disabled"


def check_multi_az(db_instance):
    return "Multi-AZ Enabled" if db_instance.get("MultiAZ") else "Single-AZ"


def check_instance_type(db_instance):
    instance_class = db_instance["DBInstanceClass"]
    if instance_class.startswith("db.t3") or instance_class.startswith("db.t2"):
        return "Instance Type: General Purpose"
    elif instance_class.startswith("db.m5") or instance_class.startswith("db.r5"):
        return "Instance Type: High Performance"
    return f"Instance Type: {instance_class}"


def check_idle_instance(db_instance):
    db_identifier = db_instance["DBInstanceIdentifier"]
    metrics = cloudwatch_client.get_metric_data(
        MetricDataQueries=[
            {
                "Id": "cpu",
                "MetricStat": {
                    "Metric": {
                        "Namespace": "AWS/RDS",
                        "MetricName": "CPUUtilization",
                        "Dimensions": [{"Name": "DBInstanceIdentifier", "Value": db_identifier}],
                    },
                    "Period": 86400,
                    "Stat": "Average",
                },
                "ReturnData": True,
            }
        ],
        StartTime=datetime.now(timezone.utc).replace(month=1, day=1),
        EndTime=datetime.now(timezone.utc),
    )
    cpu_utilization = metrics["MetricDataResults"][0]["Values"]
    if cpu_utilization and max(cpu_utilization) < 10:
        return "Idle (Low Utilization)"
    return "Active (Utilized)"


def check_security_group_rules(db_instance):
    sg_ids = db_instance["VpcSecurityGroups"]
    for sg in sg_ids:
        sg_id = sg["VpcSecurityGroupId"]
        response = ec2_client.describe_security_groups(GroupIds=[sg_id])
        for sg in response["SecurityGroups"]:
            for rule in sg["IpPermissions"]:
                for ip_range in rule.get("IpRanges", []):
                    if ip_range["CidrIp"] == "0.0.0.0/0":
                        return "Warning: Open to the world"
    return "Secure (Restricted Access)"


def check_storage_type(db_instance):
    storage_type = db_instance.get("StorageType", "standard")
    if storage_type == "io1":
        return "Provisioned IOPS (Optimized)"
    elif storage_type == "gp2":
        return "General Purpose SSD (Default)"
    elif storage_type == "standard":
        return "Magnetic (Legacy)"
    return f"Storage Type: {storage_type}"


def check_engine_version(db_instance):
    engine_version = db_instance["EngineVersion"]
    return "Up-to-date" if "latest" in engine_version.lower() else f"Outdated Engine Version: {engine_version}"


def check_enhanced_monitoring(db_instance):
    return "Enabled" if db_instance.get("MonitoringInterval", 0) > 0 else "Disabled"


def check_performance_insights(db_instance):
    return "Enabled" if db_instance.get("PerformanceInsightsEnabled") else "Disabled"


def check_backup_retention(db_instance):
    retention_days = db_instance.get("BackupRetentionPeriod", 0)
    if retention_days >= 7:
        return f"Retention Period: {retention_days} days"
    return f"Warning: Retention Period is {retention_days} days (less than recommended)"


def check_maintenance_window(db_instance):
    maintenance_window = db_instance.get("PreferredMaintenanceWindow")
    return f"Maintenance Window: {maintenance_window}" if maintenance_window else "No Maintenance Window Configured"


def check_iam_authentication(db_instance):
    return "Enabled" if db_instance.get("IAMDatabaseAuthenticationEnabled") else "Disabled"


def check_public_snapshot_sharing():
    response = rds_client.describe_db_snapshots()
    public_snapshots = [
        snap["DBSnapshotIdentifier"]
        for snap in response["DBSnapshots"]
        if snap.get("PubliclyAccessible")
    ]
    return f"Warning: Public Snapshots Found - {public_snapshots}" if public_snapshots else "No Public Snapshots Found"


def check_deletion_protection(db_instance):
    return "Enabled" if db_instance.get("DeletionProtection") else "Disabled"


def main():
    log_info("Starting RDS Best Practices Check...")
    separator()

    log_info("Checklist of Best Practices to Verify:")
    for index, check in enumerate(CHECKS, 1):
        print(f"{index}. {check}")
    separator()

    response = rds_client.describe_db_instances()
    db_instances = response["DBInstances"]

    for db_instance in db_instances:
        db_identifier = db_instance["DBInstanceIdentifier"]
        log_info(f"Checking RDS Instance: {db_identifier}")
        separator()

        log_info(f"Encryption: {check_rds_encryption(db_instance)}")
        log_info(f"Public Access: {check_public_accessibility(db_instance)}")
        log_info(f"Automated Backups: {check_automated_backups(db_instance)}")
        log_info(f"Multi-AZ Deployment: {check_multi_az(db_instance)}")
        log_info(f"Instance Type: {check_instance_type(db_instance)}")
        log_info(f"Idle Status: {check_idle_instance(db_instance)}")
        log_info(f"Security Group Rules: {check_security_group_rules(db_instance)}")
        log_info(f"Storage Type: {check_storage_type(db_instance)}")
        log_info(f"Engine Version: {check_engine_version(db_instance)}")
        log_info(f"Enhanced Monitoring: {check_enhanced_monitoring(db_instance)}")
        log_info(f"Performance Insights: {check_performance_insights(db_instance)}")
        log_info(f"Backup Retention Period: {check_backup_retention(db_instance)}")
        log_info(f"Maintenance Window: {check_maintenance_window(db_instance)}")
        log_info(f"IAM Authentication: {check_iam_authentication(db_instance)}")
        log_info(f"Deletion Protection: {check_deletion_protection(db_instance)}")
        separator()

    log_info(f"Snapshot Sharing: {check_public_snapshot_sharing()}")
    log_info("RDS Best Practices Check completed.")
    separator()


if __name__ == "__main__":
    main()
