data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "eks-cluster01" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//eks?ref=day_35_38"

  common_tags = var.common_tags
  project_name = format("%s-01", var.project_name)
  region = var.region
  ssm_vpc             = var.ssm_vpc
  ssm_private_subnets = var.ssm_private_subnets
  ssm_pod_subnets     = var.ssm_pod_subnets
  ssm_natgw_eips      = var.ssm_natgw_eips

  eks_api_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

  karpenter_capacity = var.karpenter_capacity

  istio_ssm_target_group = var.ssm_target_groups[0]

}

module "eks-cluster02" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//eks?ref=day_35_38"

  common_tags = var.common_tags
  project_name = format("%s-02", var.project_name)
  region = var.region
  ssm_vpc             = var.ssm_vpc
  ssm_private_subnets = var.ssm_private_subnets
  ssm_pod_subnets     = var.ssm_pod_subnets
  ssm_natgw_eips      = var.ssm_natgw_eips

  eks_api_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]

  karpenter_capacity = var.karpenter_capacity

  istio_ssm_target_group = var.ssm_target_groups[1]

}
