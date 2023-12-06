## Example module

```terraform
module "vpc" {
  source              = "../../modules/aws/vpc"
  env                 = local.env
  region              = local.region
  vpc_cidr            = "10.1.0.0/16"
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  private_eks_subnets = var.private_eks_subnets
}

variable "public_subnets" {
  type = map(any)
  default = {
    public_1a = {
      az   = "us-east-1a"
      cidr = "10.1.1.0/24"
    }
    public_1b = {
      az   = "us-east-1b"
      cidr = "10.1.2.0/24"
    }
    public_1c = {
      az   = "us-east-1c"
      cidr = "10.1.3.0/24"
    }
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    private_1a = {
      az   = "us-east-1a"
      cidr = "10.1.10.0/23"
    }
    private_1b = {
      az   = "us-east-1b"
      cidr = "10.1.12.0/23"
    }
    private_1c = {
      az   = "us-east-1c"
      cidr = "10.1.14.0/23"
    }
  }
}

variable "private_eks_subnets" {
  type = map(any)
  default = {
    private_eks_1a = {
      az   = "us-east-1a"
      cidr = "10.1.28.0/22"
    }
    private_eks_1b = {
      az   = "us-east-1b"
      cidr = "10.1.32.0/22"
    }
    private_eks_1c = {
      az   = "us-east-1c"
      cidr = "10.1.36.0/22"
    }
  }
}
```
