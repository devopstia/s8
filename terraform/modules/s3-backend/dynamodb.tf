resource "aws_dynamodb_table" "tf-state-lock" {
  provider       = aws.source
  name           = format("%s-%s-%s-tf-state-lock", var.common_tags["environment"], var.common_tags["project"], var.common_tags["owner"])
  hash_key       = "LockID"
  # read_capacity  = 20
  # write_capacity = 20
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge(var.common_tags,{
  Name           = format("%s-%s-%s-tf-state-lock", var.common_tags["environment"], var.common_tags["project"], var.common_tags["owner"])
  }
  ) 
}
