output "eks_api_endpoint" {
  value       = module.esk-csi.eks_api_endpoint
  description = "API server endpoint"
}

output "eks_filesystem_id" {
  value       = module.esk-csi.eks_filesystem_id
  description = "The EFS filesystem id"
}
