resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "worker"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = data.aws_subnets.eks_private.ids
  ami_type        = "CUSTOM"
  labels = {
    role = "worker"
  }

  launch_template {
    name    = aws_launch_template.worker.name
    version = aws_launch_template.worker.latest_version
  }

  scaling_config {
    desired_size = var.worker_instance_count
    max_size     = var.worker_instance_count
    min_size     = var.worker_instance_count
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
    aws_launch_template.worker,
    aws_iam_instance_profile.nodes,
    aws_eks_addon.vpc
  ]
}
