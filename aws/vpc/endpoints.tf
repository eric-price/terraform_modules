locals {
  private_route_table_ids = [
    for subnet_key, subnet in var.private_subnets :
    aws_route_table.private[subnet_key].id
  ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = local.private_route_table_ids

  tags = {
    Name        = "${var.env}_s3"
  }
}
