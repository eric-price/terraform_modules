resource "aws_eks_addon" "vpc" {
  count                       = var.addons["vpc"]["enable"] ? 1 : 0
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.addons["vpc"]["version"]
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
  count                       = var.addons["ebs"]["enable"] ? 1 : 0
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.addons["ebs"]["version"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}

resource "aws_eks_addon" "coredns" {
  count                       = var.addons["coredns"]["enable"] ? 1 : 0
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "coredns"
  addon_version               = var.addons["coredns"]["version"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}

resource "aws_eks_addon" "kube-proxy" {
  count                       = var.addons["kube_proxy"]["enable"] ? 1 : 0
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.addons["kube_proxy"]["version"]
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}

resource "helm_release" "metrics_server" {
  count            = var.addons["metrics_server"]["enable"] ? 1 : 0
  namespace        = "kube-system"
  create_namespace = false
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = var.addons["metrics_server"]["version"]
  values = [
    <<-EOT
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: role
              operator: In
              values:
              - core
    EOT
  ]
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.core
  ]
}

module "lb_controller" {
  count                  = var.addons["lb_controller"]["enable"] ? 1 : 0
  source                 = "../../aws/eks-addons/lb_controller"
  cluster_name           = var.env
  env                    = var.env
  irsa_oidc_provider_arn = aws_iam_openid_connect_provider.cluster.arn
  controller_version     = var.addons["lb_controller"]["version"]
  depends_on = [
    aws_eks_node_group.core
  ]
}

module "karpenter" {
  count                      = var.addons["karpenter"]["enable"] ? 1 : 0
  source                     = "../../aws/eks-addons/karpenter"
  env                        = var.env
  region                     = var.region
  cluster_name               = aws_eks_cluster.cluster.name
  cluster_endpoint           = aws_eks_cluster.cluster.endpoint
  irsa_oidc_provider_arn     = aws_iam_openid_connect_provider.cluster.arn
  eks_node_role_arn          = aws_iam_role.nodes.arn
  karpenter_version          = var.addons["karpenter"]["version"]
  worker_node_types          = var.worker_node_types
  worker_node_capacity_types = var.worker_node_capacity_types
  worker_node_arch           = var.worker_node_arch
  depends_on = [
    aws_eks_node_group.core
  ]
}

resource "helm_release" "external_secrets_operator" {
  count            = var.addons["external_secrets"]["enable"] ? 1 : 0
  namespace        = "external-secrets"
  create_namespace = true
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.addons["external_secrets"]["version"]
  depends_on = [
    aws_eks_node_group.core
  ]
}

resource "helm_release" "reloader" {
  count            = var.addons["reloader"]["enable"] ? 1 : 0
  namespace        = var.env
  create_namespace = false
  name             = "stakater"
  repository       = "https://stakater.github.io/stakater-charts"
  chart            = "reloader"
  version          = var.addons["reloader"]["version"]
  set {
    name  = "reloader.namespaceSelector"
    value = var.env
  }
  depends_on = [
    aws_eks_node_group.core
  ]
}
