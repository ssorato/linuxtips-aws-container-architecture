data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

module "ecs_ec2" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_ec2?ref=day2"

  common_tags              = var.common_tags
  aws_region               = var.aws_region
  project_name             = var.project_name
  alb_ingress_cidr_enabled = one(var.alb_ingress_cidr_enabled) == "auto" ? ["${chomp(data.http.my_public_ip.response_body)}/32"] : var.alb_ingress_cidr_enabled
  ecs                      = var.ecs
}

output "ecs_alb" {
  value       = module.ecs_ec2.ecs_alb_dns_name
  description = "The ECS ALB dns name"
}