module "network" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//network?ref=day1"

  common_tags           = var.common_tags
  aws_region            = var.aws_region
  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  databases_subnet_cidr = var.databases_subnet_cidr
}
