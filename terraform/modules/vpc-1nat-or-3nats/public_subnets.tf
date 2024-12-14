resource "aws_subnet" "public" {
  for_each = tomap({ for idx, cidr in var.public_subnet_cidrs : idx => cidr })

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, each.key)
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-%d", var.tags["environment"], each.key + 1)
  }
}


