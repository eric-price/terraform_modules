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
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          requirements:
            - key: kubernetes.io/arch
              operator: In
              values: ["amd64"]
            - key: kubernetes.io/os
              operator: In
              values: ["linux"]
            - key: karpenter.sh/capacity-type
              operator: In
              values: ["spot", "on-demand"]
            - key: node.kubernetes.io/instance-type
              operator: In
              values: ["t3.medium", "t3a.medium"]
            - key: karpenter.k8s.aws/instance-generation
              operator: Gt
              values: ["2"]
            - key: karpenter.k8s.aws/instance-cpu
              operator: Lt
              values: ["9"]
            - key: karpenter.k8s.aws/instance-hypervisor
              operator: In
              values: ["nitro"]
          nodeClassRef:
            name: default
          kubelet:
            maxPods: 110
      limits:
        cpu: 1000
      disruption:
        consolidationPolicy: WhenUnderutilized
        expireAfter: 720h # 30 * 24h = 720h
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
