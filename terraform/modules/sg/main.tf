resource "aws_security_group" "sg" {
  name        = format("%s-%s-${var.sg_name}", var.tags["environment"], var.tags["project"])
  description = "Allow SSH, HTTP, and other ports"
  vpc_id      = data.aws_vpc.vpc.id

  # Create ingress rules dynamically for each port in the list
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = format("%s-%s-${var.sg_name}", var.tags["environment"], var.tags["project"])
  })
}
