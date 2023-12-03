resource "aws_eks_fargate_profile" "fargate" {
  count                  = var.fargate ? 1 : 0
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "fargate"
  pod_execution_role_arn = aws_iam_role.fargate[0].arn
  subnet_ids             = data.aws_subnets.eks_private.ids

  selector {
    namespace = "fargate"
  }
}
