output "endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "certificate" {
  description = "EKS cluster certificate"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "version" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.cluster.platform_version
}

output "oidc_provider_arn" {
  description = "EKS OIDC ARN"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

output "node_role_arn" {
  description = "EKS node role ARN"
  value       = aws_iam_role.nodes.arn
}
