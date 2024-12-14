# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  for_each = aws_subnet.public # One EIP per public subnet
  tags = {
    Name = format("eip-nat-%s", each.key)
  }
}

# Create NAT Gateways
resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public # One NAT Gateway per public subnet

  allocation_id = aws_eip.nat[each.key].id # Use the EIP for the NAT Gateway
  subnet_id     = each.value.id            # Associate with the public subnet

  tags = {
    Name = format("nat-gateway-%s", each.key)
  }
}











