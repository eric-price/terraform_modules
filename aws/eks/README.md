<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ../../aws/eks-addons/karpenter | n/a |
| <a name="module_lb-controller"></a> [lb-controller](#module\_lb-controller) | ../../aws/eks-addons/lb-controller | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube-proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_alias.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_ami.bottlerocket_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnets.eks_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [tls_certificate.cluster](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addon_coredns_version"></a> [addon\_coredns\_version](#input\_addon\_coredns\_version) | n/a | `any` | n/a | yes |
| <a name="input_addon_ebs_version"></a> [addon\_ebs\_version](#input\_addon\_ebs\_version) | n/a | `any` | n/a | yes |
| <a name="input_addon_karpenter_version"></a> [addon\_karpenter\_version](#input\_addon\_karpenter\_version) | n/a | `any` | n/a | yes |
| <a name="input_addon_kube_proxy_version"></a> [addon\_kube\_proxy\_version](#input\_addon\_kube\_proxy\_version) | n/a | `any` | n/a | yes |
| <a name="input_addon_lb_controller_version"></a> [addon\_lb\_controller\_version](#input\_addon\_lb\_controller\_version) | n/a | `any` | n/a | yes |
| <a name="input_addon_vpc_version"></a> [addon\_vpc\_version](#input\_addon\_vpc\_version) | n/a | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | n/a | `any` | n/a | yes |
| <a name="input_core_node_count"></a> [core\_node\_count](#input\_core\_node\_count) | n/a | `any` | n/a | yes |
| <a name="input_core_node_type"></a> [core\_node\_type](#input\_core\_node\_type) | n/a | `any` | n/a | yes |
| <a name="input_core_node_volume_size"></a> [core\_node\_volume\_size](#input\_core\_node\_volume\_size) | n/a | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | n/a | `any` | n/a | yes |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate"></a> [certificate](#output\_certificate) | EKS cluster certificate |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | EKS cluster endpoint |
| <a name="output_name"></a> [name](#output\_name) | EKS cluster name |
| <a name="output_node_role_arn"></a> [node\_role\_arn](#output\_node\_role\_arn) | EKS node role ARN |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | EKS OIDC ARN |
| <a name="output_version"></a> [version](#output\_version) | EKS cluster name |
<!-- END_TF_DOCS -->