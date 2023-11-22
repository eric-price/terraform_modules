Example module:

```terraform
module "karpenter" {
  source                 = "../../modules/karpenter"
  env                    = local.env
  region                 = local.region
  cluster_name           = module.eks-cluster.name
  cluster_endpoint       = module.eks-cluster.endpoint
  irsa_oidc_provider_arn = module.eks-cluster.oidc_provider_arn
  eks_node_role_arn      = module.eks-cluster.node_role_arn
  karpenter_version      = "v0.32.1"
}
```
