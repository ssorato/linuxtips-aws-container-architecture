common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "ecs-final-project-vpc"
  step       = "multiregion-vpc"
}

project_name = "linuxtips-multiregion"

region      = "us-east-1"
region_peer = "us-east-2"

vpc_ssm      = "/linuxtips-multiregion/vpc/vpc_id"
vpc_ssm_peer = "/linuxtips-multiregion/vpc/vpc_id"
