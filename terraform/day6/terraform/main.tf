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

module "ecs_app" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_app?ref=day6"

  common_tags             = var.common_tags
  aws_region              = var.aws_region
  project_name            = var.project_name
  ssm_vpc_id              = var.ssm_vpc_id
  ssm_private_subnet_list = var.ssm_private_subnet_list
  ssm_alb_listener_arn    = var.ssm_alb_listener_arn
  ecs_service             = var.ecs_service
  common_scale            = var.common_scale
  cloudwatch_scale        = var.cloudwatch_scale
  tracking_scale_cpu      = var.tracking_scale_cpu
  tracking_scale_requests = var.tracking_scale_requests
  ssm_alb_arn             = var.ssm_alb_arn
  container_image         = var.container_image

  depends_on = [module.ecs_fargate]
}

output "ecs_alb" {
  value       = module.ecs_fargate.ecs_alb_dns_name
  description = "The ECS ALB dns name"
}
