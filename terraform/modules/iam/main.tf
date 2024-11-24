# Specify the provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Create an IAM User
resource "aws_iam_user" "example_user" {
  name = "example-user"
  tags = {
    Name           = "example-user"
    owner          = "EK TECH SOFTWARE SOLUTION"
    environment    = "dev"
    project        = "del"
    created_by     = "Terraform"
    cloud_provider = "aws"
  }
}

# Attach a policy to the user (optional)
resource "aws_iam_user_policy" "example_user_policy" {
  name = "example-user-policy"
  user = aws_iam_user.example_user.name

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