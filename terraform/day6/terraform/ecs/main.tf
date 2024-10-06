data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

module "ecs_fargate" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_fargate?ref=day5"

  common_tags              = var.common_tags
  aws_region               = var.aws_region
  project_name             = var.project_name
  alb_ingress_cidr_enabled = one(var.alb_ingress_cidr_enabled) == "auto" ? ["${chomp(data.http.my_public_ip.response_body)}/32"] : var.alb_ingress_cidr_enabled
  capacity_providers       = var.capacity_providers
}


output "ecs_alb" {
  value       = module.ecs_fargate.ecs_alb_dns_name
  description = "The ECS ALB dns name"
}
