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

module "jenkins-sg" {
  source     = "../../../../modules/sg"
  aws_region = "us-east-1"
  sg_name    = "jenkins-master"
  ingress_ports = [
    22,
    80,
    443,
    8080
  ]
  tags = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "development"
    "project"        = "alpha"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}