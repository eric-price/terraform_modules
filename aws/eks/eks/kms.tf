resource "aws_kms_key" "eks" {
  description         = "Encrypt EKS secrets"
  enable_key_rotation = true
  multi_region        = true
}

resource "aws_kms_alias" "eks" {
  name          = "alias/eks-${var.cluster_name}"
  target_key_id = aws_kms_key.eks.key_id
}
