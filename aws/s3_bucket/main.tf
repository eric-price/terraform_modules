resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    service   = var.service
  }
}

resource "aws_s3_bucket_logging" "logging" {
  count         = var.logging ? 1 : 0
  bucket        = aws_s3_bucket.bucket.id
  target_bucket = "logs-${data.aws_caller_identity.current.account_id}"
  target_prefix = "s3/${aws_s3_bucket.bucket.id}/"
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = var.versioning ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
