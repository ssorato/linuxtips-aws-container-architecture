common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "ecs-final-project-vpc"
  step       = "cluster"
}

project_name = "sales-cluster"

region = "us-east-1"

ssm_vpc_id = "/linuxtips-multiregion/vpc/vpc_id"

ssm_public_subnets = [
  "/linuxtips-multiregion/vpc/public/us-east-1a",
  "/linuxtips-multiregion/vpc/public/us-east-1b",
  "/linuxtips-multiregion/vpc/public/us-east-1c"
]

enable_bastion = true
