data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc_id
}

data "aws_vpc" "main" {
  id = data.aws_ssm_parameter.vpc.value
}

data "aws_ssm_parameter" "private_subnet" {
  count = length(var.ssm_private_subnet_list)
  name  = var.ssm_private_subnet_list[count.index]
}

data "aws_ssm_parameter" "public_subnet" {
  count = length(var.ssm_public_subnet_list)
  name  = var.ssm_public_subnet_list[count.index]
}
