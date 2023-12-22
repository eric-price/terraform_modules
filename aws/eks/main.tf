resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = data.aws_subnets.eks_private.ids
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.cluster.id]
  }

  enabled_cluster_log_types = var.log_types

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "172.20.0.0/16"
  }

  tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

  depends_on = [
    aws_iam_role.cluster,
    aws_kms_key.eks,
    aws_security_group.cluster
  ]
}

resource "kubernetes_namespace" "env" {
  metadata {
    name = var.env
    labels = {
      istio-injection = "enabled"
    }
  }
}
