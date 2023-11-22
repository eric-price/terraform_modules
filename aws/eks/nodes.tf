resource "aws_eks_node_group" "core" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "core"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = data.aws_subnets.eks_private.ids
  ami_type        = "CUSTOM"
  labels = {
    role = "core"
  }

  launch_template {
    name    = aws_launch_template.core.name
    version = aws_launch_template.core.latest_version
  }

  scaling_config {
    desired_size = var.core_node_count
    max_size     = var.core_node_count
    min_size     = var.core_node_count
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_iam_role.nodes,
    aws_eks_cluster.cluster,
    aws_launch_template.core,
    aws_eks_addon.vpc
  ]
}
