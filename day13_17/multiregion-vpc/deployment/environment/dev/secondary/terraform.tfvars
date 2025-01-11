common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  project    = "ecs-final-project"
  step       = "multiregion-vpc"
}

project_name = "linuxtips-multiregion"
region       = "us-east-2"

vpc_cidr = "172.16.0.0/16"

private_subnets = [
  {
    name              = "private-us-east-2a"
    cidr              = "172.16.0.0/20"
    availability_zone = "us-east-2a"
  },
  {
    name              = "private-us-east-2b"
    cidr              = "172.16.16.0/20",
    availability_zone = "us-east-2b"
  },
  {
    name              = "private-us-east-2c"
    cidr              = "172.16.32.0/20"
    availability_zone = "us-east-2c"
  }
]

unique_natgw = true

public_subnets = [
  {
    name              = "public-us-east-2a"
    cidr              = "172.16.48.0/24"
    availability_zone = "us-east-2a"
  },
  {
    name              = "public-us-east-2b"
    cidr              = "172.16.49.0/24"
    availability_zone = "us-east-2b"
  },
  {
    name              = "public-us-east-2c"
    cidr              = "172.16.50.0/24"
    availability_zone = "us-east-2c"
  }
]