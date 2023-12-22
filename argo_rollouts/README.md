<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.argocd](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_rollouts_version"></a> [argo\_rollouts\_version](#input\_argo\_rollouts\_version) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | n/a | `string` | n/a | yes |
| <a name="input_loadbalancer_dns"></a> [loadbalancer\_dns](#input\_loadbalancer\_dns) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->