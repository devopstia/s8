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

locals {
  aws_region    = "us-east-1"
  key_name      = "terraform-aws"
  instance_type = "t2.micro"
  resource_type = "jenkins-master"
  root_volume   = 40
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "development"
    "project"        = "alpha"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

module "jenkins-master" {
  source        = "../../../modules/jenkins-simple"
  aws_region    = local.aws_region
  key_name      = local.key_name
  instance_type = local.instance_type
  resource_type = local.resource_type
  root_volume   = local.root_volume
  tags          = local.tags
}