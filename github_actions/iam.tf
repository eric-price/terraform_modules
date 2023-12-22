locals {
  irsa_oidc_provider_url = replace(aws_iam_openid_connect_provider.gha.arn, "/^(.*provider/)/", "")
  account_id             = data.aws_caller_identity.current.account_id
}

resource "aws_iam_openid_connect_provider" "gha" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.gha.certificates[0].sha1_fingerprint]
  url             = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gha.arn]
    }
    condition {
      test     = "StringLike"
      variable = "${local.irsa_oidc_provider_url}:sub"
      values   = ["repo:eric-price/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.irsa_oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "gha" {
  name               = "github-actions-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    aws_iam_policy.gha.arn
  ]
}

resource "aws_iam_policy" "gha" {
  name        = "github-actions-${var.env}"
  description = "Policy for Github actions"
  policy      = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*"
    ]
  }
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
}
