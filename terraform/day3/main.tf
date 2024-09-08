data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

module "ecs_app" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_app?ref=day3"

  common_tags = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day3"
  }
  aws_region   = var.aws_region
  project_name = "linuxtips"

  ssm_vpc_id = "/linuxtips/vpc/vpc_id"

  ssm_private_subnet_list = [
    "/linuxtips/vpc/subnet_private_us_east_1a_id",
    "/linuxtips/vpc/subnet_private_us_east_1b_id",
    "/linuxtips/vpc/subnet_private_us_east_1c_id"
  ]

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
    service_launch_type = "EC2"
    service_task_count  = 1
    service_hosts       = ["linuxtips.mydomain.fake"]
  }

}

