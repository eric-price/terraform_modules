## Example module and backend

```terraform
# Terraform S3 Backend (for state storage)
# comment out on intial run. See readme for more details.
terraform {
  backend "s3" {
    profile        = "sandbox"
    bucket         = "terraform-${data.aws_caller_identity.current.account_id}"
    key            = local.env
    region         = local.region
    encrypt        = true
    dynamodb_table = "terraform_lock"
  }
}

module "terraform" {
  source = "../../modules/terraform"
}
```
