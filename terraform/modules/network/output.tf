output "ssm_parameter_vpc" {
  value       = aws_ssm_parameter.vpc.id
  description = "AWS SSM parameter store VPC id"
  sensitive   = false
}

output "ssm_parameter_private_subnets" {
  value       = aws_ssm_parameter.private_subnets[*].id
  description = "AWS SSM parameter store private subnets id"
  sensitive   = false
}

output "ssm_parameter_public_subnets" {
  value       = aws_ssm_parameter.public_subnets[*].id
  description = "AWS SSM parameter store public subnets id"
  sensitive   = false
}

output "ssm_parameter_database_subnets" {
  value       = aws_ssm_parameter.database_subnets[*].id
  description = "AWS SSM parameter store database subnets id"
  sensitive   = false
}

