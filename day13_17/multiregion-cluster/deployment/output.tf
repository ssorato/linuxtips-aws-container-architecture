output "lb_internal_arn" {
  value       = aws_ssm_parameter.lb_internal_arn.id
  description = "AWS SSM parameter store ALB arn"
}

output "lb_internal_listener_arn" {
  value       = aws_ssm_parameter.lb_internal_listener_arn.id
  description = "AWS SSM parameter store ALB internal arn"
}

output "service_discovery_cloudmap_name" {
  value       = aws_ssm_parameter.service_discovery_cloudmap_name.id
  description = "AWS SSM parameter store Service Connect name"
}

output "service_discovery_cloudmap_id" {
  value       = aws_ssm_parameter.service_discovery_cloudmap_id.id
  description = "AWS SSM parameter store Service Discovery Namespace id"
}

output "service_discovery_service_connect_name" {
  value       = aws_ssm_parameter.service_discovery_service_connect_name.id
  description = "AWS SSM parameter store Service Connect name"
}

output "service_discovery_service_connect_id" {
  value       = aws_ssm_parameter.service_discovery_service_connect_id.id
  description = "AWS SSM parameter store Service Connect Namespace id"
}

output "vpc_link" {
  value       = aws_ssm_parameter.vpc_link.id
  description = "AWS SSM parameter store VPC Link id"
}

output "vpc_link_arn" {
  value       = aws_ssm_parameter.vpc_link_arn.id
  description = "AWS SSM parameter store VPC Link arn"
}
