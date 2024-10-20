module "ecs_fargate" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_fargate?ref=day9"

  common_tags              = var.common_tags
  aws_region               = var.aws_region
  project_name             = var.project_name
  ssm_vpc_id               = var.ssm_vpc_id
  ssm_public_subnet_list   = var.ssm_public_subnet_list
  ssm_private_subnet_list  = var.ssm_private_subnet_list
  alb_ingress_cidr_enabled = one(var.alb_ingress_cidr_enabled) == "auto" ? ["${chomp(data.http.my_public_ip.response_body)}/32"] : var.alb_ingress_cidr_enabled
  capacity_providers       = var.capacity_providers
}


output "ecs_alb" {
  value       = module.ecs_fargate.ecs_alb_dns_name
  description = "The ECS ALB dns name"
}

output "ecs_alb_internal_dns_name" {
  value       = module.ecs_fargate.ecs_alb_dns_name
  description = "The ECS ALB internal dns name"
}

output "bastion_vm_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The bastion vm public ip"
}
