## Example module

```terraform
module "s3_bucket" {
  source      = "../aws/s3_bucket"
  service     = var.name
  bucket_name = "${var.name}-${var.env}"
  env         = var.env
  versioning  = true
  logging     = false
}
```
