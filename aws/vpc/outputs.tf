output "logs_bucket" {
  description = "Logs bucket ID"
  value       = aws_s3_bucket.logs.id
}

output "https_internal" {
  description = "Internal HTTPs group ID"
  value       = aws_security_group.https_internal.id
}

output "https_public" {
  description = "Public HTTPs group ID"
  value       = aws_security_group.https_public.id
}

output "id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
