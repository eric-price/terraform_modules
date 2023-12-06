resource "aws_dynamodb_table" "terraform" {
    name           = "terraform_lock"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}
