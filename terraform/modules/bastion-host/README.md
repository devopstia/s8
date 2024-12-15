# s8

## get sg info
```t
data "aws_security_group" "sg" {
  filter {
    name   = "tag:Name"
    values = ["ec2_security_group"] # Replace with the actual Name tag value of your VPC
  }
  filter {
    name   = "tag:environment"
    values = ["dev"] # Replace with the actual Name tag value of your VPC
  }
}

output "sg" {
  value = data.aws_security_group.sg.id
}

output "name" {
  value = data.aws_security_group.sg.name
}
```