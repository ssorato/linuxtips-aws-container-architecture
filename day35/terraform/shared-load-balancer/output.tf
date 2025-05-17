output "ssm_target_group_01" {
  value       = module.share-load-balancer.ssm_target_group_01
  description = "The target id about EKS cluster 01"
}

output "ssm_target_group_02" {
  value       = module.share-load-balancer.ssm_target_group_02
  description = "The target id about EKS cluster 02"
}