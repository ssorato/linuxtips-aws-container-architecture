module "vpc" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//vpc?ref=day_13_17"

  common_tags     = var.common_tags
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  unique_natgw    = var.unique_natgw
}