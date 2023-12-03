### Private ###

resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "${var.env}_${each.key}"
    type = "private"
  }
}

resource "aws_route" "nat_gw" {
  for_each               = var.private_subnets
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw[replace(each.key, "private", "public")].id
}

resource "aws_route_table_association" "private_route" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "eks_private_route" {
  for_each       = var.private_eks_subnets
  subnet_id      = aws_subnet.eks[each.key].id
  route_table_id = aws_route_table.private[replace(each.key, "eks_", "")].id
}

### Public ###

resource "aws_route_table" "public" {
  for_each = var.public_subnets
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "${var.env}_${each.key}"
    type = "public"
  }
}

resource "aws_route" "internet_gw" {
  for_each               = var.public_subnets
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_route" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}
