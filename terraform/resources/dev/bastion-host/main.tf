provider "aws" {
  region = "us-east-1"
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

terraform {
  backend "s3" {
    bucket         = "development-del-s8-tf-state"
    key            = "bastion-host/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "development-del-s8-tf-state-lock"
    encrypt        = true
  }
}

module "bastion-host" {
  source        = "../../../modules/bastion-host"
  aws_region    = "us-east-1"
  key_name      = "terraform-aws"
  instance_type = "t2.micro"
  resource_type = "bastion-host"
  root_volume   = 8
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "development"
    "project"        = "alpha"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}