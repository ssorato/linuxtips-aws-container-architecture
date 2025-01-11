common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  project    = "ecs-final-project"
  step       = "multiregion-vpc"
}

project_name = "linuxtips-multiregion"
region       = "us-east-1"

vpc_cidr = "10.0.0.0/16"

private_subnets = [
  {
    name              = "private-us-east-1a"
    cidr              = "10.0.0.0/20"
    availability_zone = "us-east-1a"
  },
  {
    name              = "private-us-east-1b"
    cidr              = "10.0.16.0/20",
    availability_zone = "us-east-1b"
  },
  {
    name              = "private-us-east-1c"
    cidr              = "10.0.32.0/20"
    availability_zone = "us-east-1c"
  }
]

unique_natgw = true

public_subnets = [
  {
    name              = "public-us-east-1a"
    cidr              = "10.0.48.0/24"
    availability_zone = "us-east-1a"
  },
  {
    name              = "public-us-east-1b"
    cidr              = "10.0.49.0/24"
    availability_zone = "us-east-1b"
  },
  {
    name              = "public-us-east-1c"
    cidr              = "10.0.50.0/24"
    availability_zone = "us-east-1c"
  }
]