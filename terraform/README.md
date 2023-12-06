Bootstrap account for terraform:
- Run `terraform init` in account directory with "terraform" block commented out
- Run `terraform apply` to create s3 bucket to store the state file and dynamodb table for state lock
- Uncomment "terraform" block and run `terraform init` to migrate state to s3
- Remove local state file
