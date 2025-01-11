module "sales_api" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs-service?ref=day_13_17"

  common_tags = var.common_tags
  region      = var.region
  ecs_name    = var.cluster_name

  ecs_service_name      = "sales-api-${var.region}"
  ecs_service_port      = "8080"
  ecs_service_cpu       = 256
  ecs_service_memory_mb = 512

  common_scale = {
    task_minimum = 1
    task_maximum = 3
    task_desired = 1
  }

  container_image = "fidelissauro/sales-rest-api:latest"

  alb_listener_arn       = data.aws_ssm_parameter.listener.value
  alb_listener_https_arn = data.aws_ssm_parameter.listener_https.value
  alb_arn                = data.aws_ssm_parameter.alb.value

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

  service_launch_type = [{
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }]

  deployment_controller = "ECS"

  service_hosts = [
    "sales-api.${format("%s.internal.com", var.cluster_name)}",
    "${var.sales_dns_name}"
  ]

  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = [
    data.aws_ssm_parameter.subnet_1.value,
    data.aws_ssm_parameter.subnet_2.value,
    data.aws_ssm_parameter.subnet_3.value,
  ]

  environment_variables = [
    {
      name  = "AWS_REGION"
      value = var.region
    },
    {
      name  = "SNS_SALES_PROCESSING_TOPIC"
      value = aws_sns_topic.main.arn
    },
    {
      name  = "SSM_PARAMETER_STORE_STATE"
      value = var.parameter_store_state_name
    },
    {
      name  = "DYNAMO_SALES_TABLE"
      value = var.sales_table_name
    }
  ]
}