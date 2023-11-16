resource "aws_security_group" "cluster" {
  name        = "eks-cluster-${var.cluster_name}"
  description = "EKS node security"
  vpc_id      = data.aws_vpc.main.id
  egress {
    description = "full outbound"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }
  ingress {
    cidr_blocks = ["10.8.0.0/16"]
    description = "vpn"
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }
  ingress {
    description = "self reference"
    from_port   = "0"
    protocol    = "-1"
    self        = "true"
    to_port     = "0"
  }
  tags = {
    Name        = "eks-cluster-${var.env}"
  }
}
