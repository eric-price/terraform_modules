resource "helm_release" "cert_manager" {
  namespace        = "cert-manager"
  create_namespace = true
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  values = [
    <<-EOT
    installCRDs: false
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
    kubectl_manifest.crds
  ]
}

data "http" "crd_manifest" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_manager_version}/cert-manager.crds.yaml"
}

locals {
  crd_manifests = split("---", data.http.crd_manifest.response_body)
}

resource "kubectl_manifest" "crds" {
  count     = length(local.crd_manifests)
  yaml_body = element(local.crd_manifests, count.index)
}

resource "kubernetes_secret" "cloudflare_token" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "cert-manager"
  }
  data = {
    api-token = jsondecode(data.aws_secretsmanager_secret_version.cloudflare_api_token.secret_string)["cert-manager"]
  }
  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "cluster_issuer_staging" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-staging
      namespace: cert-manager
    spec:
      acme:
        email: mail@eric-price.net
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          name: letsencrypt-staging
        solvers:
        - dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare-api-token-secret
                key: api-token
  YAML

  depends_on = [
    kubernetes_secret.cloudflare_token,
    helm_release.cert_manager
  ]
}

resource "kubectl_manifest" "cluster_issuer_prod" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
      namespace: cert-manager
    spec:
      acme:
        email: mail@eric-price.net
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          name: letsencrypt-prod
        solvers:
        - dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare-api-token-secret
                key: api-token
  YAML

  depends_on = [
    kubernetes_secret.cloudflare_token,
    helm_release.cert_manager
  ]
}
