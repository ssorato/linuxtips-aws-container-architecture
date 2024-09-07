module "network" {
  source = "../modules/network"

  common_tags = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day1"
  }
  aws_region            = var.aws_region
  project_name          = "linuxtips"
  vpc_cidr              = "10.0.0.0/16"
  private_subnet_cidr   = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnet_cidr    = ["10.0.48.0/24", "10.0.49.0/24", "10.0.50.0/24"]
  databases_subnet_cidr = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
}
