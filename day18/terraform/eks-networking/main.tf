module "esk-networking" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//networking?ref=day18"

  common_tags = var.common_tags

  project_name = var.project_name

  region = var.region

  vpc_cidr             = var.vpc_cidr
  vpc_additional_cidrs = var.vpc_additional_cidrs

  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
  database_nacl_rules = var.database_nacl_rules
}
