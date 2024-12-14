resource "aws_route_table" "public" {
  for_each = aws_subnet.public # Create one route table for each public subnet
  vpc_id   = aws_vpc.main.id   # Reference the main VPC

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id # Use the internet gateway for public subnets
  }

  tags = {
    Name = format("public-route-table-%s-%s", var.tags["environment"], each.key)
  }
}


# Associate the Public Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public # Iterate over the public subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id # Reference the public route table for each subnet
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private # Iterate over private subnets
  vpc_id   = aws_vpc.main.id    # Reference the main VPC
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id # Reference the correct NAT gateway using the subnet key
  }
  tags = {
    Name = format("private-route-table-%s-%s", var.tags["environment"], each.key)
  }
}

# Associate the Private Route Table with Private Subnets
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private # Iterate over the private subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id # Reference the private route table for each subnet
}

