data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc_id
}

data "aws_vpc" "main" {
  id = data.aws_ssm_parameter.vpc.value
}

data "aws_ssm_parameter" "public_subnet" {
  count = length(var.ssm_public_subnet_list)
  name  = var.ssm_public_subnet_list[count.index]
}
