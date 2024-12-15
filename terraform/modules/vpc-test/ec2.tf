provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name        = "ssh"
  description = "Allow SSH and HTTP"
  vpc_id      = "vpc-05f0e7b2c39d9ad98"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "ssh"
    environment    = "dev"
    project        = "vpc_demo"
    created_by     = "terraform"
    cloud_provider = "aws"
  }
}
resource "aws_instance" "private" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = "subnet-0f75a54d3c61a0f65"
  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }
  tags = {
    Name           = "private"
    environment    = "dev"
    project        = "vpc_demo"
    created_by     = "terraform"
    cloud_provider = "aws"
  }
}

resource "aws_instance" "public" {
  ami                    = "ami-0e2c8caa4b6378d8c"
  instance_type          = "t2.micro"
  key_name               = "terraform-aws"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = "subnet-0baafd046915ff37d"
  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }
  tags = {
    Name           = "public"
    environment    = "dev"
    project        = "vpc_demo"
    created_by     = "terraform"
    cloud_provider = "aws"
  }
}