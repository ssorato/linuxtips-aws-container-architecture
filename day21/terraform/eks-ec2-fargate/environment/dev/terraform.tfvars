common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day21"
}

project_name = "linuxtips-cluster"
region       = "us-east-1"

ssm_vpc = "/linuxtips-vpc/vpc/id"
ssm_public_subnets = [
  "/linuxtips-vpc/subnets/public/us-east-1a/linuxtips-public-1a",
  "/linuxtips-vpc/subnets/public/us-east-1b/linuxtips-public-1b",
  "/linuxtips-vpc/subnets/public/us-east-1c/linuxtips-public-1c"
]
ssm_private_subnets = [
  "/linuxtips-vpc/subnets/private/us-east-1a/linuxtips-private-1a",
  "/linuxtips-vpc/subnets/private/us-east-1b/linuxtips-private-1b",
  "/linuxtips-vpc/subnets/private/us-east-1c/linuxtips-private-1c"
]
ssm_pod_subnets = [
  "/linuxtips-vpc/subnets/private/us-east-1a/linuxtips-pods-1a",
  "/linuxtips-vpc/subnets/private/us-east-1b/linuxtips-pods-1b",
  "/linuxtips-vpc/subnets/private/us-east-1c/linuxtips-pods-1c"
]
ssm_natgw_eips = [
  "/linuxtips-vpc/subnets/public/us-east-1a/natgw-eip"
]

k8s_version = "1.31"

node_group = {
  node = {
    capacity_type = "ON_DEMAND"
    labels = {
      "capacity/os"   = "AMAZON_LINUX"
      "capacity/arch" = "x86_64"
    }
    instance_sizes = [
      "t3a.medium",
      "t3.medium"
    ]
    min     = 1
    max     = 2
    desired = 2
  },
  node-spot = {
    capacity_type = "SPOT"
    labels = {
      "capacity/os"   = "AMAZON_LINUX"
      "capacity/arch" = "x86_64"
    }
    instance_sizes = [
      "t3a.medium",
      "t3.medium"
    ]
    min     = 1
    max     = 3
    desired = 2
  },
  graviton = {
    capacity_type = "ON_DEMAND"
    ami_type      = "AL2023_ARM_64_STANDARD"
    labels = {
      "capacity/os"   = "AMAZON_LINUX"
      "capacity/arch" = "ARM64"
    }
    instance_sizes = [
      "t4g.medium",
      "t4g.large"
    ]
    min     = 1
    max     = 3
    desired = 2
  }
}

fargate_namespace = "chip"

