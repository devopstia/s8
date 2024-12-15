data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc-dev"]
  }
}

data "aws_subnet" "public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["dev-public-subnet-1"]
  }
}