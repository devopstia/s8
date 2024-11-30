# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Define a list of secret names
variable "secret_names" {
  default = [
    "DB_USERNAME",
    "DB_PASSWORD"
  ]
}

# Create Secret Manager placeholders
resource "aws_secretsmanager_secret" "secrets" {
  for_each = toset(var.secret_names)

  name = each.key

  tags = {
    Name           = each.key
    owner          = "EK TECH SOFTWARE SOLUTION"
    environment    = "dev"
    project        = "del"
    created_by     = "Terraform"
    cloud_provider = "aws"
  }
}
