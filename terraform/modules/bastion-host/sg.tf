resource "aws_security_group" "ssh_sg" {
  name        = format("%s-%s-sg", var.tags["environment"], var.tags["project"])
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.vpc.id
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

  tags = merge(var.tags, {
    Name = format("%s-%s-sg", var.tags["environment"], var.tags["project"])
  })
}