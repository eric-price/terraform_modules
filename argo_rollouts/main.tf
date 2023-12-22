resource "helm_release" "argocd" {
  namespace        = "argo-rollouts"
  create_namespace = true
  name             = "argo-rollouts"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  version          = var.argo_rollouts_version
  values = ["${templatefile("../../modules/argo_rollouts/files/values.yaml", {
    ENV     = var.env
    FQDN    = var.fqdn
    LB_NAME = "${var.env}-public-application"
  })}"]
}
