aws_region    = "us-east-1"
key_name      = "terraform-aws"
instance_type = "t2.medium"
resource_type = "jenkins-master-2"
root_volume   = 40
tags = {
  "owner"          = "EK TECH SOFTWARE SOLUTION"
  "environment"    = "prod"
  "project"        = "beta"
  "create_by"      = "Terraform"
  "cloud_provider" = "aws"
}