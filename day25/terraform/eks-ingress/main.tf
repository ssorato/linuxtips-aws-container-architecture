data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "eks-ingress" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//eks-ingress?ref=day25"

  common_tags = var.common_tags

  project_name = var.project_name

  region = var.region

  ssm_vpc             = var.ssm_vpc
  ssm_public_subnets  = var.ssm_public_subnets
  ssm_private_subnets = var.ssm_private_subnets
  ssm_pod_subnets     = var.ssm_pod_subnets
  ssm_natgw_eips      = var.ssm_natgw_eips

  k8s_version             = var.k8s_version
  api_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

  karpenter_capacity = var.karpenter_capacity

  route53 = var.route53

  ingress_nlb = merge(
    var.ingress_nlb, # keep here - data.http.myip will overwrite value
    {
      inbound_cidrs = ["${chomp(data.http.myip.response_body)}/32"]
    }
  )

  ingress_controller_config = var.ingress_controller_config
}
