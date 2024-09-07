output "ecs_alb_dns_name" {
  value       = aws_lb.ecs_alb.dns_name
  description = "The ECS ALB dns name"
}

output "ssm_alb_arn" {
  value       = aws_ssm_parameter.alb_arn.id
  description = "AWS SSM parameter store ALB arn"
  sensitive   = false
}

output "ssm_alb_listener_arn" {
  value       = aws_ssm_parameter.alb_listener_arn.id
  description = "AWS SSM parameter store ALB listner arn"
  sensitive   = false
}
