# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Define a list of usernames
variable "user_list" {
  default = ["user1", "user2", "user3"]
}

# Create the STUDENT-GROUP
resource "aws_iam_group" "student_group" {
  name = "STUDENT-GROUP"
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

# Add each user to the STUDENT-GROUP
resource "aws_iam_group_membership" "group_membership" {
  name = "student-group-membership"

  group = aws_iam_group.student_group.name

  users = [for user in aws_iam_user.users : user.name]
}

# Attach the AdministratorAccess policy to the group
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.student_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}