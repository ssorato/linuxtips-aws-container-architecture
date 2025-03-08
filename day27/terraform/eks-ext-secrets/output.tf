output "eks_api_endpoint" {
  value       = module.eks-ext-secrets.eks_api_endpoint
  description = "API server endpoint"
}
