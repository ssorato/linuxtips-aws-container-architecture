module "water" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_service?ref=day10"

  common_tags  = var.common_tags
  project_name = var.project_name
  aws_region   = var.aws_region
  ecs_name     = format("ecs-%s", var.project_name)

  ecs_service_name      = "nutrition-water"
  ecs_service_port      = "30000"
  ecs_service_cpu       = 256
  ecs_service_memory_mb = 512

  common_scale = {
    task_minimum = 1
    task_maximum = 3
    task_desired = 1
  }

  container_image = "fidelissauro/water-grpc-service:latest"

  alb_listener_arn = data.aws_ssm_parameter.listener_internal.value
  alb_arn          = data.aws_ssm_parameter.alb_internal.value

  service_task_execution_role_arn = aws_iam_role.main.arn

  service_healthcheck = {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/healthz"
    port                = 8080
  }

  service_launch_type = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]

  service_discovery_namespace = data.aws_ssm_parameter.service_discovery_namespace.value

  service_hosts = [
    "water.${format("%s.internal.com", var.project_name)}"
  ]

  environment_variables = [
    {
      name  = "ZIPKIN_COLLECTOR_ENDPOINT"
      value = "http://jaeger-collector.${format("%s.internal.com", var.project_name)}:80"
    }
  ]

  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  # Service Connect
  use_service_connect  = true
  service_protocol     = "grpc"
  service_connect_name = data.aws_ssm_parameter.service_connect_name.value
  service_connect_arn  = data.aws_ssm_parameter.service_connect_namespace_arn.value
}