output "eks_api_endpoint" {
  value       = module.eks-istio.eks_api_endpoint
  description = "API server endpoint"
}
