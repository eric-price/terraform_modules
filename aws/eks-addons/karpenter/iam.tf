locals {
  irsa_oidc_provider_url = replace(var.irsa_oidc_provider_arn, "/^(.*provider/)/", "")
  account_id             = data.aws_caller_identity.current.account_id
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "karpenter-irsa-${var.env}"
  role = aws_iam_role.karpenter_irsa.name
}

# Create service account role for spot support
resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}

resource "aws_iam_role" "karpenter_node" {
  name = "karpenter-node-${var.env}"
  assume_role_policy = jsonencode({
    Statement : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Principal : {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ],
    Version : "2012-10-17"
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  tags = {
    service   = "karpenter"
  }
}

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.irsa_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.irsa_oidc_provider_url}:sub"
      values   = ["system:serviceaccount:kube-system:karpenter"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.irsa_oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "karpenter_irsa" {
  name               = "karpenter-irsa-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
  managed_policy_arns = [
    aws_iam_policy.karpenter_irsa.arn
  ]
  tags = {
    service   = "karpenter"
  }
}

resource "aws_iam_policy" "karpenter_irsa" {
  name = "karpenter-irsa-${var.env}"
  policy = templatefile("../../modules/aws/eks-addons/karpenter/files/irsa_policy.json", {
    AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
    AWS_REGION     = var.region
    CLUSTER_NAME   = var.cluster_name
  })
  tags = {
    service   = "karpenter"
  }
}
