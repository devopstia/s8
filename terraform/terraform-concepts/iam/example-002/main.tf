# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Define a list of users
variable "user_list" {
  default = [
    "user1",
    "user3",
    "user4",
    "user1",
    "user5",
    "user6"
  ]
}

# Create IAM Users
resource "aws_iam_user" "users" {
  for_each = toset(var.user_list)

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

# Attach a policy to each user (optional)
resource "aws_iam_user_policy" "user_policies" {
  for_each = aws_iam_user.users

  name = "${each.key}-policy"
  user = each.value.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = "*"
      }
    ]
  })
}