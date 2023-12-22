# Ref values: https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml

resource "helm_release" "argocd" {
  namespace        = "argocd"
  create_namespace = true
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  values = ["${templatefile("../../modules/argocd/files/values.yaml", {
    ENV     = var.env
    FQDN    = var.fqdn
    LB_NAME = "${var.env}-public-application"
  })}"]
}
