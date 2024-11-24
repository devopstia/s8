# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

# Define the secret name
variable "secret_name" {
  default = "my-secret-placeholder"
}

# Create the secret placeholder in AWS Secrets Manager
resource "aws_secretsmanager_secret" "placeholder" {
  name        = var.secret_name
  description = "This is a placeholder for a secret managed by Terraform."

  tags = {
    Name        = "Secret Placeholder"
    Environment = "dev"
    CreatedBy   = "Terraform"
  }
}

# Output the secret ARN (optional)
output "secret_arn" {
  value = aws_secretsmanager_secret.placeholder.arn
}

# Output the secret name (optional)
output "secret_name" {
  value = aws_secretsmanager_secret.placeholder.name
}
