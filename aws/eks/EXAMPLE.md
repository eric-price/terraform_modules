## Example module

```terraform
variable "addons" {
  type = map(any)
  default = {
    vpc = {
      enable  = true
      version = "v1.14.1-eksbuild.1"
    }
    ebs = {
      enable  = true
      version = "v1.24.1-eksbuild.1"
    }
    coredns = {
      enable  = true
      version = "v1.10.1-eksbuild.2"
    }
    kube_proxy = {
      enable  = true
      version = "v1.28.1-eksbuild.1"
    }
    karpenter = {
      enable  = true
      version = "v0.32.1"
    }
    lb_controller = {
      enable  = true
      version = "1.6.2"
    }
    metrics_server = {
      enable = true
      version = "3.11.0"
    }
    external_secrets = {
      enable = true
      version = "0.9.9"
      reloader_version = "1.0.52"
    }
    reloader = {
      enable = true
      version = "1.0.52"
    }
  }
}

module "eks-cluster" {
  source                      = "../../modules/aws/eks"
  cluster_name                = local.env
  env                         = local.env
  region                      = local.region
  cluster_version             = "1.28"
  fargate                     = false
  addons                      = var.addons
  core_node_type              = "m5a.large"
  core_node_count             = 2
  core_node_volume_size       = 100
  log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}
```
