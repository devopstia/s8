# IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_ami_creation_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# IAM policy to allow the Lambda function to create AMIs and read EC2 instances
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_ami_creation_policy"
  description = "IAM policy for Lambda to create AMIs and log to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateImage",
          "ec2:DescribeInstances",
          "ec2:CreateTags",
          "ec2:DescribeImages", // Permission to describe AMIs
          "ec2:DeregisterImage" // Permission to deregister AMIs
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*" // Allow logging across all log groups
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda function
resource "aws_lambda_function" "create_ami" {
  function_name = "createAMIfromTaggedInstances"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.8"
  timeout       = 120

  # The following assumes you have a ZIP file with your Lambda code
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/createAMIfromTaggedInstances" # Replace with your Lambda function's name
  # Optionally, set retention in days
  retention_in_days = 14 # Set the retention policy (14 days, for example)
}

# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "weekly_ami_backup" {
  name                = "weekly-ami-backup"
  description         = "Triggers every weekday at 3 AM EST"
  schedule_expression = "cron(0 8 ? * MON-FRI *)"
}

# Target for the Event Rule
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.weekly_ami_backup.name
  target_id = "invokeLambdaFunction"
  arn       = aws_lambda_function.create_ami.arn
}

# Permission for CloudWatch to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_ami.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_ami_backup.arn
}