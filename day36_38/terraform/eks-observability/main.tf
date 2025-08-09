module "eks-observability" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//eks-observability?ref=day36_38"

  common_tags = var.common_tags
  project_name = var.project_name
  region = var.region
  ssm_vpc             = var.ssm_vpc
  ssm_public_subnets = var.ssm_public_subnets
  ssm_private_subnets = var.ssm_private_subnets
  ssm_pod_subnets     = var.ssm_pod_subnets
  ssm_natgw_eips      = var.ssm_natgw_eips

  eks_api_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]
  karpenter_capacity = var.karpenter_capacity

  route53 = var.route53
  certificate_arn = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? null : data.aws_ssm_parameter.acm_arn[0].value

  alb_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

}
