resource "aws_security_group" "cluster" {
  name        = "eks-cluster-${var.cluster_name}"
  description = "EKS cluster security"
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
    description = "self reference"
    from_port   = "0"
    protocol    = "-1"
    self        = "true"
    to_port     = "0"
  }
  ingress {
    security_groups = [aws_security_group.node.id]
    description     = "eks node group"
    from_port       = "0"
    protocol        = "-1"
    self            = "false"
    to_port         = "0"
  }
  tags = {
    Name = "eks-cluster-${var.env}"
  }
}

resource "aws_security_group" "node" {
  name        = "eks-node-${var.cluster_name}"
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
    description = "self reference"
    from_port   = "0"
    protocol    = "-1"
    self        = "true"
    to_port     = "0"
  }
  tags = {
    Name                     = "eks-node-${var.env}"
    "karpenter.sh/discovery" = var.cluster_name
  }
}
