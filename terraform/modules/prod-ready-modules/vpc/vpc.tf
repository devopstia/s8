resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = format("%s-%s-vpc", var.tags["environment"], var.tags["project"])
    },
  )
}