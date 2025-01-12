module "health_api" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_service?ref=day12"

  common_tags  = var.common_tags
  project_name = var.project_name
  aws_region   = var.aws_region
  ecs_name     = format("ecs-%s", var.project_name)

  ecs_service_name      = "nutrition-health-api"
  ecs_service_port      = "8080"
  ecs_service_cpu       = 256
  ecs_service_memory_mb = 512

  common_scale = {
    task_minimum = 1
    task_maximum = 3
    task_desired = 1
  }

  container_image = "fidelissauro/health-api:latest"

  alb_listener_arn = data.aws_ssm_parameter.listener_internal.value
  alb_arn          = data.aws_ssm_parameter.alb_internal.value

  service_task_execution_role_arn = aws_iam_role.main.arn

  service_healthcheck = {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/healthcheck"
    port                = 8080
  }

  service_launch_type = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]

  service_hosts = [
    "health.${format("%s.internal.com", var.project_name)}"
  ]

  service_discovery_namespace = data.aws_ssm_parameter.service_discovery_namespace.value

  environment_variables = [
    {
      name  = "ZIPKIN_COLLECTOR_ENDPOINT"
      value = "http://jaeger-collector.${format("%s.internal.com", var.project_name)}:80"
    },
    {
      name  = "BMR_SERVICE_ENDPOINT",
      value = "nutrition-bmr.${format("%s.discovery.com", var.project_name)}:30000"
    },
    {
      name  = "IMC_SERVICE_ENDPOINT",
      value = "nutrition-imc.${format("%s.discovery.com", var.project_name)}:30000"
    },
    {
      name  = "RECOMMENDATIONS_SERVICE_ENDPOINT",
      value = "nutrition-recommendations.${format("%s.discovery.com", var.project_name)}:30000"
    },
    {
      name  = "version"
      value = timestamp()
    }
  ]

  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  # Service Connect
  use_service_connect  = false # CodeDeploy not works with Service Connect because it needs a load balancer
  service_protocol     = "http"
  service_connect_name = data.aws_ssm_parameter.service_connect_name.value
  service_connect_arn  = data.aws_ssm_parameter.service_connect_namespace_arn.value

  # CodeDeploy
  deployment_controller = "CODE_DEPLOY"

  #codedeploy_strategy = "CodeDeployDefault.ECSAllAtOnce" # Blue Green
  codedeploy_strategy = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes" # Canary deployment
}
