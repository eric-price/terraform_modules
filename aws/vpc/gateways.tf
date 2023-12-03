resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = var.env
  }
}

resource "aws_eip" "nat_gw" {
  for_each = var.public_subnets
  domain   = "vpc"
  tags = {
    Name        = "${var.env}-${each.key}"
  }
}

resource "aws_nat_gateway" "gw" {
  for_each      = var.public_subnets
  allocation_id = aws_eip.nat_gw[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.env}_${each.key}"
  }

  depends_on = [aws_internet_gateway.gw]
}
