common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day10"
}
aws_region   = "us-east-1"
project_name = "linuxtips"

ssm_vpc_id = "/linuxtips/vpc/vpc_id"

ssm_public_subnet_list = [
  "/linuxtips/vpc/subnet_public_us_east_1a_id",
  "/linuxtips/vpc/subnet_public_us_east_1b_id",
  "/linuxtips/vpc/subnet_public_us_east_1c_id"
]

ssm_private_subnet_list = [
  "/linuxtips/vpc/subnet_private_us_east_1a_id",
  "/linuxtips/vpc/subnet_private_us_east_1b_id",
  "/linuxtips/vpc/subnet_private_us_east_1c_id"
]

capacity_providers = ["FARGATE", "FARGATE_SPOT"]
