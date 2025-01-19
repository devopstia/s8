resource "aws_instance" "example" {
  ami           = "ami-04b4f1a9cf54c11d0" # Replace with the AMI ID you want to use
  instance_type = "t2.micro"              # Replace with your desired instance type
  # Optional: Add a tag to the instance
  key_name  = "terraform-aws"
  subnet_id = aws_subnet.public_2.id
  tags = {
    Name = "bastion-host"
  }
  # Optional: Create a security group that allows SSH access
  vpc_security_group_ids = [
    aws_security_group.sg.id,
  ]
}

# Optional: Create a security group that allows SSH access
resource "aws_security_group" "sg" {
  name_prefix = "allow_ssh"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [
    #   "98.196.226.173/32",
    #   "108.244.84.187/32",
    #   "70.26.112.43/32",
    #   "76.242.51.172/32"
    # ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}