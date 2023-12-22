# data "http" "crd_manifest" {
#   url = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_manager_version}/cert-manager.crds.yaml"
# }
#
# data "kubectl_file_documents" "crds" {
#   content = data.http.crd_manifest.response_body
# }

data "aws_secretsmanager_secret" "cloudflare_api_token" {
  name = "cloudflare-api-token"
}

data "aws_secretsmanager_secret_version" "cloudflare_api_token" {
  secret_id = data.aws_secretsmanager_secret.cloudflare_api_token.id
}
