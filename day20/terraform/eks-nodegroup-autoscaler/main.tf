data "http" "myip" {
  url = "http://ifconfig.me"
}

module "esk-vanilla" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//eks-vanilla?ref=day20"

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

  node_group = var.node_group
}
