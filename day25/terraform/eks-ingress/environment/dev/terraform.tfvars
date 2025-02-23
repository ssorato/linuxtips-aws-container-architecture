common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day25"
  step       = "eks-ingress"
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

# See README references abou ami_ssm
karpenter_capacity = [
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
  },
  {
    name       = "health-api-capacity"
    workload   = "health-api-workload"
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
# route53 - certificate not used

ingress_controller_config = {
  kind            = "Deployment" # Deployment / DaemonSet - dafault Deployment
  min_replicas    = 3
  max_replicas    = 5
  requests_cpu    = "250m"
  requests_memory = "128Mi"
  limits_cpu      = "500m"
  limits_memory   = "256Mi"
  fargate_ns      = "" # the namespace used by ingress controller - empty uses karpenter
}

ingress_nlb = {
  create        = true
  ingress_type  = "nginx" # nginx or traefik
}
