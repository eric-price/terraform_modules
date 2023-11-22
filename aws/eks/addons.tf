resource "aws_eks_addon" "vpc" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.addon_vpc_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  configuration_values = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
    }
  })
  depends_on = [aws_eks_cluster.cluster]
}

resource "aws_eks_addon" "ebs" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.addon_ebs_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "coredns"
  addon_version               = var.addon_coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.addon_kube_proxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}
