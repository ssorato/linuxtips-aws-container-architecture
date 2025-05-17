common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day35"
  step       = "eks-control-plane"
}

project_name = "linuxtips-control-plane"
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

karpenter_capacity = [
  {
    name               = "general"
    workload           = "general"
    ami_family         = "Bottlerocket"
    ami_ssm            = "/aws/service/bottlerocket/aws-k8s-1.31/x86_64/latest/image_id"
    instance_family    = ["t3", "t3a"]
    instance_sizes     = ["micro", "small", "medium"]
    capacity_type      = ["spot", "on-demand"]
    availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  },
]

ssm_acm_arn = "/linuxtips-ingress/acm/arn"

clusters_configs = [
  {
    cluster_name = "linuxtips-cluster-01"
  },
  {
    cluster_name = "linuxtips-cluster-02"
  }
]