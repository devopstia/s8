
# Resource: aws_eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

resource "aws_eip" "nat1" {
  vpc = true
}

resource "aws_eip" "nat2" {
  vpc = true
}
