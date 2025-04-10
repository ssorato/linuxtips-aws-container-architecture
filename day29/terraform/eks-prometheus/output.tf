output "eks_api_endpoint" {
  value       = module.eks-prometheus.eks_api_endpoint
  description = "API server endpoint"
}
