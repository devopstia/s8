resource "aws_subnet" "private" {
  for_each = tomap({ for idx, cidr in var.private_subnet_cidrs : idx => cidr })

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, each.key)
  map_public_ip_on_launch = false # Private subnets should not map public IPs

  tags = {
    Name = format("%s-private-subnet-%d", var.tags["environment"], each.key + 1)
  }
}