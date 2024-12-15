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
    key            = "aws-secret-manager/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "development-del-s8-tf-state-lock"
    encrypt        = true
  }
}

module "aws-secret-manager" {
  source     = "../../../modules/aws-secret-manager"
  aws_region = "us-east-1"
  secret_names = [
    "DB_USERNAME",
    "DB_PASSWORD"
  ]
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "development"
    "project"        = "alpha"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}