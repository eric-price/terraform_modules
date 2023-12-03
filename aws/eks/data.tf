data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  tags = {
    env  = var.env
    Name = var.env
  }
}

data "aws_subnets" "eks_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  tags = {
    env  = var.env
    type = "eks-private"
  }
}

data "aws_ami" "bottlerocket_image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${var.cluster_version}-x86_64-*"]
  }
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
