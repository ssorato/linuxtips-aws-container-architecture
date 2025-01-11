module "cluster" {
  source = "git::https://github.com/ssorato/linuxtips-aws-container-architecture-tf-modules.git//cluster?ref=day_13_17"

  common_tags  = var.common_tags
  project_name = var.project_name

  region = var.region
  vpc_id = data.aws_ssm_parameter.vpc.value

  private_subnets = data.aws_ssm_parameter.private_subnets[*].value
  public_subnets  = data.aws_ssm_parameter.public_subnets[*].value

  acm_certs = data.aws_acm_certificate.main[*].arn
}