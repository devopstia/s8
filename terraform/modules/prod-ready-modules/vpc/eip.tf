resource "aws_eip" "nat" {
  count = var.tags["environment"] == "production" ? length(var.availability_zones) : 1
  vpc   = true
  tags = merge(var.tags, {
    Name = format("%s-%s-eip-${count.index + 1}-${element(var.availability_zones, count.index)}", var.tags["environment"], var.tags["project"])
    },
  )
}