data "aws_ssm_parameter" "vpc_id" {
  name = var.ssm_vpc_id
}

data "aws_ssm_parameter" "private_subnet" {
  count = length(var.ssm_private_subnet_list)
  name  = var.ssm_private_subnet_list[count.index]
}

data "aws_ssm_parameter" "alb_listener_arn" {
  name = var.ssm_alb_listener_arn
}

data "aws_ssm_parameter" "alb_arn" {
  name = var.ssm_alb_arn
}

data "aws_ssm_parameter" "service_discovery_namespace" {
  name = var.ssm_service_discovery_namespace
}
