resource "aws_iam_role" "cluster" {
  name = "eks-cluster-${var.cluster_name}"
  assume_role_policy = jsonencode({
    Statement : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Principal : {
          "Service" : "eks.amazonaws.com"
        }
      }
    ],
    Version : "2012-10-17"
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

resource "aws_iam_role" "nodes" {
  name = "eks-nodes-${var.cluster_name}"
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
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.cluster.url
}
