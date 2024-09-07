module "ecs_app" {
  source = "../ecs_service"

  ecs_service_name                = var.ecs_service.name
  ecs_service_port                = var.ecs_service.port
  ecs_service_cpu                 = var.ecs_service.cpu
  ecs_service_memory_mb           = var.ecs_service.memory_mb
  ecs_name                        = var.ecs_service.ecs_name
  vpc_id                          = data.aws_ssm_parameter.vpc_id.value
  private_subnets                 = data.aws_ssm_parameter.private_subnet[*].value
  alb_listener_arn                = data.aws_ssm_parameter.alb_listener_arn.value
  service_task_execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}
