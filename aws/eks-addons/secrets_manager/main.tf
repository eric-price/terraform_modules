resource "helm_release" "csi_driver" {
  namespace        = "kube-system"
  create_namespace = false
  name             = "csi-secrets-store"
  repository       = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart            = "secrets-store-csi-driver"
  version          = var.csi_driver_version
}

resource "helm_release" "secrets_manager" {
  namespace        = "kube-system"
  create_namespace = false
  name             = "secrets-provider-aws"
  repository       = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart            = "secrets-store-csi-driver-provider-aws"
  version          = var.secrets_provider_version

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

  depends_on = [helm_release.csi_driver]
}
