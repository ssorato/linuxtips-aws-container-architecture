module "ecs_app" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_app?ref=day7"

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
  efs_volumes             = var.efs_volumes
}
