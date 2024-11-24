# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Define a list of usernames
variable "user_list" {
  default = [
    "user1",
    "user3",
    "user4",
    "user5"
  ]
}

# Create IAM Users
resource "aws_iam_user" "users" {
  count = length(var.user_list) # Loop through the list of users

  name = var.user_list[count.index] # Assign the username

  tags = {
    Name           = var.user_list[count.index]
    owner          = "EK TECH SOFTWARE SOLUTION"
    environment    = "dev"
    project        = "del"
    created_by     = "Terraform"
    cloud_provider = "aws"
  }
}

# Attach a policy to each user
resource "aws_iam_user_policy" "user_policies" {
  count = length(var.user_list) # Loop through the same list

  name = "${var.user_list[count.index]}-policy"
  user = aws_iam_user.users[count.index].name

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