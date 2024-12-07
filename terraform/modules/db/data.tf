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
  value     = jsondecode(data.aws_secretsmanager_secret_version.db_username.secret_string)
  sensitive = true
}

output "db_password" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)
  sensitive = true
}