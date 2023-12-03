resource "aws_sqs_queue" "karpenter" {
  message_retention_seconds = 300
  name                      = "${var.cluster_name}-karpenter"
}

resource "aws_sqs_queue_policy" "karpenter" {
  policy    = data.aws_iam_policy_document.node_termination_queue.json
  queue_url = aws_sqs_queue.karpenter.url
}

data "aws_iam_policy_document" "node_termination_queue" {
  statement {
    resources = [aws_sqs_queue.karpenter.arn]
    sid       = "EC2InterruptionPolicy"
    actions   = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com",
        "sqs.amazonaws.com"
      ]
    }
  }
}
