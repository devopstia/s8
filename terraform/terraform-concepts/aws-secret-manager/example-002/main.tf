# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

# Define the secret name and key-value pairs
variable "secret_name" {
  default = "my-secret"
}

variable "secret_values" {
  default = {
    username = "admin"
    password = "P@ssw0rd!"
    api_key  = "12345-abcde-67890-fghij"
  }
}

# Create the secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "example" {
  name        = var.secret_name
  description = "This is an example secret managed by Terraform."

  tags = {
    Name        = "Example Secret"
    Environment = "dev"
    CreatedBy   = "Terraform"
  }
}

# Store the secret values in AWS Secrets Manager
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode(var.secret_values)
}

# Output the secret ARN (optional)
output "secret_arn" {
  value = aws_secretsmanager_secret.example.arn
}

# Output the secret name (optional)
output "secret_name" {
  value = aws_secretsmanager_secret.example.name
}
