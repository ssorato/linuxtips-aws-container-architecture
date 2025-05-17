data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

module "share-load-balancer" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//shared-load-balancer?ref=day35"

  common_tags = var.common_tags
  project_name = var.project_name
  region = var.region
  ssm_vpc             = var.ssm_vpc
  ssm_public_subnets  = var.ssm_public_subnets
  alb_public_access_cidrs = ["${chomp(data.http.myip.response_body)}/32"]
  route53 = var.route53
  routing_weight = var.routing_weight

}
