output "eks_api_endpoint" {
  value       = module.eks-argo.eks_api_endpoint
  description = "API server endpoint"
}
