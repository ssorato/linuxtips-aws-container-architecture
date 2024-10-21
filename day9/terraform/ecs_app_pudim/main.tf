data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

module "ecs_service_pudim" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_service?ref=day9"

  common_tags  = var.common_tags
  project_name = var.project_name
  aws_region   = var.aws_region

  ecs_service_name                = var.ecs_service.name
  ecs_service_port                = var.ecs_service.port
  ecs_service_cpu                 = var.ecs_service.cpu
  ecs_service_memory_mb           = var.ecs_service.memory_mb
  ecs_name                        = var.ecs_service.ecs_name
  vpc_id                          = data.aws_ssm_parameter.vpc_id.value
  private_subnets                 = data.aws_ssm_parameter.private_subnet[*].value
  alb_listener_arn                = data.aws_ssm_parameter.alb_listener_arn.value
  service_task_execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  environment_variables           = var.ecs_service.environment_variables
  secrets                         = var.ecs_service.secrets
  capabilities                    = var.ecs_service.capabilities
  service_healthcheck             = var.ecs_service.service_healthcheck
  service_launch_type             = var.ecs_service.service_launch_type
  service_hosts                   = var.ecs_service.service_hosts
  service_listener_arn            = data.aws_ssm_parameter.alb_listener_arn.value
  common_scale                    = var.common_scale
  cloudwatch_scale                = var.cloudwatch_scale
  tracking_scale_cpu              = var.tracking_scale_cpu
  tracking_scale_requests         = var.tracking_scale_requests
  alb_arn                         = data.aws_ssm_parameter.alb_arn.value
  container_image                 = var.container_image
  efs_volumes                     = []
  service_discovery_namespace     = data.aws_ssm_parameter.service_discovery_namespace.value
}
