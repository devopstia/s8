resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0866a3c8686eaeeba" 
  instance_type = "t2.micro"

  # Add a key pair for SSH access
  key_name = "terraform-aws"

  # Security Group to allow SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Associate instance with specific subnet
  subnet_id = data.aws_subnet.subnet_01.id

  # Specify the root block device to set the volume size to 30 GB and type to gp3
  root_block_device {
    volume_size = 30      # Size in GB
    volume_type = "gp3"   # Set volume type to gp3
  }

  # User data script to install Apache on Ubuntu
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              EOF

  tags = {
    "Name"           = "apche-web"
    "owner"          = "EK TECH SOFTWARE SOLUTION"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}