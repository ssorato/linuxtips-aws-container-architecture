module "jaeger-collector" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_service?ref=day9"

  common_tags  = var.common_tags
  project_name = var.project_name
  aws_region   = var.aws_region
  ecs_name     = format("ecs-%s", var.project_name)

  ecs_service_name      = "nutrition-jaeger-collector"
  ecs_service_port      = "9411"
  ecs_service_cpu       = 512
  ecs_service_memory_mb = 1024

  common_scale = {
    task_minimum = 1
    task_maximum = 1
    task_desired = 1
  }

  container_image = "jaegertracing/all-in-one:1.57"

  alb_listener_arn = data.aws_ssm_parameter.listener_internal.value
  alb_arn          = data.aws_ssm_parameter.alb_internal.value

  service_task_execution_role_arn = aws_iam_role.main.arn

  service_healthcheck = {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/"
    port                = 14269
  }

  service_launch_type = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]

  service_hosts = [
    "jaeger-collector.${format("%s.internal.com", var.project_name)}"
  ]

  environment_variables = [
    {
      name  = "COLLECTOR_ZIPKIN_HOST_PORT"
      value = ":9411"
    }
  ]

  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  service_discovery_namespace = data.aws_ssm_parameter.service_discovery_namespace.value

}