output "vpc_ssm" {
  value       = aws_ssm_parameter.vpc.name
  description = "The VPC name"
}


output "public_subnets_ssm" {
  value       = aws_ssm_parameter.public_subnets[*].name
  description = "The public subnet names"
}

output "private_subnets_ssm" {
  value       = aws_ssm_parameter.private_subnets[*].name
  description = "The private subnet names"
}
