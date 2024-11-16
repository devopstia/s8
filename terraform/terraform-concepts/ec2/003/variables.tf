variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "alpha"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

variable "resource_type" {
  type    = string
  default = "jenkins-master"
}