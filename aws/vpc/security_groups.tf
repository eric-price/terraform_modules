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

resource "aws_security_group" "https_public" {
  name        = "${var.env}-https-public"
  description = "Allow public https traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "tcp"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}-https-public"
  }
}

resource "aws_security_group" "https_internal" {
  name        = "${var.env}-https-internal"
  description = "Allow internal https traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "tcp"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      aws_vpc.main.cidr_block
    ]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}-https-internal"
  }
}
