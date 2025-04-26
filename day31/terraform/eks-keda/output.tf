output "eks_api_endpoint" {
  value       = module.eks-keda.eks_api_endpoint
  description = "API server endpoint"
}

output "heath_sqs_queue_url" {
  value       = aws_sqs_queue.health.url
  description = "The Health API SQS queue URL"
}
