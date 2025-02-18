output "eks_api_endpoint" {
  value       = module.eks-karpenter-groupless.eks_api_endpoint
  description = "API server endpoint"
}
