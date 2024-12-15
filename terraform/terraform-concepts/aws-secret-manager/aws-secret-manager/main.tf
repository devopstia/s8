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
  for_each                = toset(var.secret_names)
  recovery_window_in_days = 0 # Disable retention policy
  name                    = each.key

  tags = {
    Name           = each.key
    owner          = "EK TECH SOFTWARE SOLUTION"
    environment    = "dev"
    project        = "del"
    created_by     = "Terraform"
    cloud_provider = "aws"
  }
}



data "aws_secretsmanager_secret" "db_username" {
  name = "DB_USERNAME"
}

data "aws_secretsmanager_secret_version" "db_username" {
  secret_id = data.aws_secretsmanager_secret.db_username.id
}

data "aws_secretsmanager_secret" "db_password" {
  name = "DB_PASSWORD"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}


# ## CREATE A DATABASE WITH USERNAME AND PASSWORD
# password = data.aws_secretsmanager_secret_version.db_password.secret_string
# username = data.aws_secretsmanager_secret_version.db_username.secret_string


output "db_username" {
  value = data.aws_secretsmanager_secret_version.db_username.secret_string
}

output "db_password" {
  value = data.aws_secretsmanager_secret_version.db_password.secret_string
}