output "queue_name" {
  description = "SQS interuption queue"
  value       = aws_sqs_queue.karpenter.name
}

output "irsa_role_arn" {
  description = "IRSA role ARN"
  value       = aws_iam_role.karpenter_irsa.arn
}
