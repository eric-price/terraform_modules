resource "helm_release" "lb_controller" {
  namespace        = "kube-system"
  create_namespace = false
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = var.controller_version

  values = [
    <<-EOT
    clusterName: ${var.cluster_name}
    serviceAccount:
      create: false
      name: aws-load-balancer-controller
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

  depends_on = [kubernetes_service_account.service_account]
}

resource "kubernetes_service_account" "service_account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = aws_iam_role.lb.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "kubectl_manifest" "external_app_lb" {
  yaml_body = templatefile("../../modules/aws/eks-addons/lb_controller/files/app_lb.yaml", {
    CERT       = var.cert
    ENV        = var.env
    LB_NAME    = "${var.env}-app-external"
    LB_TYPE    = "internet-facing"
    SSL_POLICY = "ELBSecurityPolicy-FS-1-2-2019-08"
  })
}

resource "kubectl_manifest" "internal_app_lb" {
  yaml_body = templatefile("../../modules/aws/eks-addons/lb_controller/files/app_lb.yaml", {
    CERT       = var.cert
    ENV        = var.env
    LB_NAME    = "${var.env}-app-internal"
    LB_TYPE    = "internal"
    SSL_POLICY = "ELBSecurityPolicy-FS-1-2-2019-08"
  })
}
