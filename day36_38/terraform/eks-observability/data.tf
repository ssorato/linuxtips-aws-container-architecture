data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc
}

data "aws_vpc" "main" {
  id = data.aws_ssm_parameter.vpc.value
}

data "aws_ssm_parameter" "public_subnet" {
  count = length(var.ssm_public_subnets)
  name  = var.ssm_public_subnets[count.index]
}

data "aws_ssm_parameter" "acm_arn" {
  count = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1
  name  = var.create_acm_certificate == true ? aws_ssm_parameter.acm_arn[0].name : var.ssm_acm_arn
}
