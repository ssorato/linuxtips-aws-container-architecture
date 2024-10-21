common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day9"
}
aws_region   = "us-east-1"
project_name = "linuxtips"

ssm_vpc_id = "/linuxtips/vpc/vpc_id"

ssm_private_subnet_list = [
  "/linuxtips/vpc/subnet_private_us_east_1a_id",
  "/linuxtips/vpc/subnet_private_us_east_1b_id",
  "/linuxtips/vpc/subnet_private_us_east_1c_id"
]

# ECS service is associated to the public ALB
ssm_alb_arn          = "/linuxtips/ecs/lb/arn"
ssm_alb_listener_arn = "/linuxtips/ecs/lb/listerner/arn"

ecs_service = {
  name                  = "pudim"
  port                  = 80
  cpu                   = 256
  memory_mb             = 512
  ecs_name              = "ecs-linuxtips"
  environment_variables = []
  secrets               = []
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
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]
  service_hosts = [
    "pudim.linuxtips.mydomain.fake"
  ]
}

common_scale = {
  task_maximum = 1
  task_minimum = 1
  task_desired = 1
}

container_image = "fidelissauro/pudim:latest"

ssm_service_discovery_namespace = "/linuxtips/ecs/cloudmap/namespace"