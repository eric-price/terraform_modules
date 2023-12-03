resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = "${var.env}_${each.key}"
    type = "private"
  }
}

resource "aws_subnet" "eks" {
  for_each          = var.private_eks_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name                              = "${var.env}_${each.key}"
    type                              = "eks-private"
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = var.env
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name                     = "${var.env}_${each.key}"
    type                     = "public"
    "kubernetes.io/role/elb" = 1
  }
}
