common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  project    = "ecs-final-project"
  step       = "cluster"
}

project_name = "sales-cluster"
region       = "us-east-2"

ssm_vpc_id = "/linuxtips-multiregion/vpc/vpc_id"

ssm_private_subnets = [
  "/linuxtips-multiregion/vpc/private/us-east-2a",
  "/linuxtips-multiregion/vpc/private/us-east-2b",
  "/linuxtips-multiregion/vpc/private/us-east-2c"
]
ssm_public_subnets = [
  "/linuxtips-multiregion/vpc/public/us-east-2a",
  "/linuxtips-multiregion/vpc/public/us-east-2b",
  "/linuxtips-multiregion/vpc/public/us-east-2c"
]

acm_dns_certs = [
  "*.yourdomain.com"
]

