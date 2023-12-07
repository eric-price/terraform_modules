resource "helm_release" "karpenter" {
  namespace        = "kube-system"
  create_namespace = false
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.karpenter_version

  values = [
    <<-EOT
    settings:
      clusterName: ${var.cluster_name}
      clusterEndpoint: ${var.cluster_endpoint}
      interruptionQueueName: ${aws_sqs_queue.karpenter.name}
      aws:
        defaultInstanceProfile: ${aws_iam_instance_profile.karpenter.name}
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${aws_iam_role.karpenter_irsa.arn}
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
    aws_iam_role.karpenter_irsa
  ]
}

resource "kubectl_manifest" "aws_auth_config" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: aws-auth
      namespace: kube-system
    data:
      mapRoles: |
        - groups:
          - system:bootstrappers
          - system:nodes
          rolearn: "${var.eks_node_role_arn}"
          username: system:node:{{EC2PrivateDNSName}}
        - groups:
          - system:bootstrappers
          - system:nodes
          rolearn: "${aws_iam_role.karpenter_node.arn}"
          username: system:node:{{EC2PrivateDNSName}}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: Bottlerocket
      role: "karpenter-node-${var.cluster_name}"
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: "${var.cluster_name}"
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: "${var.cluster_name}"
      tags:
        platform: eks
        Name: "eks-karpenter-${var.env}"
        karpenter.sh/discovery: "${var.cluster_name}"
      metadataOptions:
        httpEndpoint: enabled
        httpProtocolIPv6: disabled
        httpPutResponseHopLimit: 2
        httpTokens: required
      blockDeviceMappings:
        # Root device
        - deviceName: /dev/xvda
          ebs:
            volumeSize: 4Gi
            volumeType: gp3
            encrypted: true
        # Data device: Container resources such as images and logs
        - deviceName: /dev/xvdb
          ebs:
            volumeSize: 20Gi
            volumeType: gp3
            encrypted: true
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = templatefile("../../modules/aws/eks-addons/karpenter/files/node_pool.yaml", {
    INSTANCE_TYPES = jsonencode(var.worker_node_types)
    CAPACITY_TYPES = jsonencode(var.worker_node_capacity_types)
    INSTANCE_ARCH  = jsonencode(var.worker_node_arch)
  })

  depends_on = [
    helm_release.karpenter
  ]
}
