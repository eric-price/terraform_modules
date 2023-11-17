Example module:

```terraform
module "eks-cluster" {
  source                   = "../../modules/aws/eks"
  cluster_name             = "sandbox"
  env                      = "sandbox"
  cluster_version          = "1.28"
  addon_vpc_version        = "v1.14.1-eksbuild.1"
  addon_ebs_version        = "v1.24.1-eksbuild.1"
  addon_coredns_version    = "v1.10.1-eksbuild.2"
  addon_kube_proxy_version = "v1.28.1-eksbuild.1"
  worker_instance_type     = "t3a.medium"
  worker_instance_count    = 2
  worker_volume_size       = 100
  log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}
```
