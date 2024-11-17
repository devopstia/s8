provider "aws" {
  region = local.aws_region
}

## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "jenkins-master" {
  source        = "../../../modules/jenkins-simple"
  aws_region    = "us-east-1"
  key_name      = "terraform-aws"
  instance_type = "t2.medium"
  resource_type = "jenkins-master"
  root_volume   = 40
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "development"
    "project"        = "beta"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}