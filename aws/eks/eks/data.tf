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
