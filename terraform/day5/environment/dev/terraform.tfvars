common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day5"
}
aws_region   = "us-east-1"
project_name = "linuxtips"

ssm_vpc_id = "/linuxtips/vpc/vpc_id"

ssm_private_subnet_list = [
  "/linuxtips/vpc/subnet_private_us_east_1a_id",
  "/linuxtips/vpc/subnet_private_us_east_1b_id",
  "/linuxtips/vpc/subnet_private_us_east_1c_id"
]

alb_ingress_cidr_enabled = ["auto"] # auto means uses the public ip of the host running terraform
capacity_providers       = ["FARGATE", "FARGATE_SPOT"]

ssm_alb_arn          = "/linuxtips/ecs/lb/arn"
ssm_alb_listener_arn = "/linuxtips/ecs/lb/listerner_arn"

ecs_service = {
  name                  = "chip"
  port                  = 8080
  cpu                   = 256
  memory_mb             = 512
  ecs_name              = "ecs-linuxtips"
  environment_variables = []
  capabilities          = ["EC2"]
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
      capacity_provider = "FARGATE"
      weight = 50
    },
    {
      capacity_provider = "FARGATE_SPOT"
      weight = 50
    }  
  ]
  service_hosts       = ["linuxtips.mydomain.fake"]
}

common_scale = {
  scale_type   = "requests_tracking" # cpu/cpu_tracking/requests_tracking
  task_maximum = 6
  task_minimum = 1
  task_desired = 3
  in_cooldown  = 60
  out_cooldown = 60
}

cloudwatch_scale = {
  out_statistic           = "Average"
  out_cpu_threshold       = 50
  out_adjustment          = 1
  out_comparison_operator = "GreaterThanOrEqualToThreshold"
  out_period              = 30
  out_evaluation_periods  = 2
  in_statistic            = "Average"
  in_cpu_threshold        = 30
  in_adjustment           = -1
  in_comparison_operator  = "LessThanOrEqualToThreshold"
  in_period               = 30
  in_evaluation_periods   = 2
}

tracking_scale_cpu      = 50
tracking_scale_requests = 20
