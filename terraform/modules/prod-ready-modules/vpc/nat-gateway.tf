resource "aws_nat_gateway" "main" {
  count         = var.tags["environment"] == "production" ? length(var.availability_zones) : 1
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  tags = merge(var.tags, {
    Name = format("%s-%s-nat-${count.index + 1}-${element(var.availability_zones, count.index)}", var.tags["environment"], var.tags["project"])
    },
  )
}