data "aws_caller_identity" "current" {}

data "tls_certificate" "gha" {
  url = "https://token.actions.githubusercontent.com"
}
