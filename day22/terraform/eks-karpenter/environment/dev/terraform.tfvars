common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day22"
  step       = "eks-karpenter"
}

project_name = "linuxtips-cluster"
region       = "us-east-1"

ssm_vpc = "/linuxtips-vpc/vpc/id"
ssm_public_subnets = [
  "/linuxtips-vpc/subnets/private/us-east-1a/linuxtips-private-1a",
  "/linuxtips-vpc/subnets/private/us-east-1b/linuxtips-private-1b",
  "/linuxtips-vpc/subnets/private/us-east-1c/linuxtips-private-1c"
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
      "t3a.medium"
    ]
    min     = 2
    max     = 3
    desired = 2
  }
}

# See README references abou ami_ssm
karpenter_capacity = [
  {
    name       = "chip-capacity"
    workload   = "linuxtips-workload"
    ami_family = "AL2023" # EC2 Node Class
    ami_ssm    = "/aws/service/eks/optimized-ami/1.31/amazon-linux-2023/x86_64/standard/recommended/image_id"
    instance_family = [
      "t3a",
      "t3"
    ]
    instance_sizes = [
      "small",
      "medium"
    ]
    capacity_type = [
      "spot"
    ]
    availability_zones = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
    ]
  },
  {
    name       = "chip-capacity"
    workload   = "chip-workload"
    ami_family = "Bottlerocket" # EC2 Node Class
    ami_ssm    = "/aws/service/bottlerocket/aws-k8s-1.31/x86_64/latest/image_id"
    instance_family = [
      "t3a",
      "t3"
    ]
    instance_sizes = [
      "micro",
      "small"
    ]
    capacity_type = [
      "spot"
    ]
    availability_zones = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
    ]
  }
]

