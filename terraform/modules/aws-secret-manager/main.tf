resource "aws_secretsmanager_secret" "secrets" {
  for_each = toset(var.secret_names)
  name     = each.key
  tags     = var.tags
}
