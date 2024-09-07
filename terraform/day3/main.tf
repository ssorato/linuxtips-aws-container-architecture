data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

module "ecs_app" {
  source = "../modules/ecs_app"

  common_tags = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
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
    name      = "chip"
    port      = 8080
    cpu       = 256
    memory_mb = 512
    ecs_name  = "cluster-ecs-linuxtips"
  }

}

