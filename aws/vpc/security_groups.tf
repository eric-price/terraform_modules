resource "aws_security_group" "internal" {
  name        = "${var.env}-internal"
  description = "Allow inbound/outbound traffic within VPC."
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  tags = {
    Name        = "${var.env}-internal"
  }
}

resource "aws_security_group" "external" {
  name        = "${var.env}-external"
  description = "Allow inbound/outbound external traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  tags = {
    Name        = "${var.env}-external"
  }
}
