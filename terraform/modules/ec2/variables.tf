variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "tags" {
    type = map(string)
    default = {
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}