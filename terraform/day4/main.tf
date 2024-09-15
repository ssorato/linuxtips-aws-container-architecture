data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}


module "ecs_app" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//ecs_app?ref=day4"

  common_tags             = var.common_tags
  aws_region              = var.aws_region
  project_name            = var.project_name
  ssm_vpc_id              = var.ssm_vpc_id
  ssm_private_subnet_list = var.ssm_private_subnet_list
  ssm_alb_listener_arn    = var.ssm_alb_listener_arn
  ecs_service             = var.ecs_service
  common_scale            = var.common_scale
  cloudwatch_scale        = var.cloudwatch_scale
}

# Pull chip image from Docker Hub and push to the ECR
resource "docker_image" "chip" {
  name = "fidelissauro/chip:latest"
}

resource "docker_tag" "ecr_chip" {
  source_image = docker_image.chip.name
  target_image = "${module.ecs_app.ecr_repo_url}:latest"
}

resource "docker_registry_image" "ecr_chip" {
  name = docker_tag.ecr_chip.target_image
}
