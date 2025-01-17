resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"

  # Add a key pair for SSH access
  key_name = "terraform-aws"

  # Security Group to allow SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Associate instance with specific subnet
  subnet_id = data.aws_subnet.subnet_01.id

  tags = {
    "Name"           = "apche-web"
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}