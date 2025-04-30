common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day34"
  step       = "eks-argocd"
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
      "t3a.medium"
    ]
    min     = 3
    max     = 4
    desired = 3
  }
}


karpenter_capacity = [
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
  },
  {
    name       = "prometheus"
    workload   = "prometheus"
    ami_family = "Bottlerocket" # EC2 Node Class
    ami_ssm    = "/aws/service/bottlerocket/aws-k8s-1.31/x86_64/latest/image_id"
    instance_family = [
      "t3a"
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
    workload   = "chip"
    ami_family = "Bottlerocket"
    ami_ssm    = "/aws/service/bottlerocket/aws-k8s-1.31/x86_64/latest/image_id"
    instance_family = [
      "t3",
      "t3a"
    ]
    instance_sizes = [
      "medium",
      "large"
    ]
    capacity_type = [
      "spot"
    ]
    availability_zones = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c"
    ]
  },
]

# route53 = {
#   dns_name    = "*.yourdomain.com" # use a wild-card due to multiple subdomains
#   hosted_zone = "YOURHOSTEDZONEID"
# }

istio_config = {
  version       = "1.25.0"
  min_replicas  = 3
  cpu_threshold = 60
}

grafana_host       = "grafanalab" # The URL will be grafanalab.yourdomain.com
jaeger_host        = "jaegerlab"  # The URL will be jaegerlab.yourdomain.com
kiali_host         = "kialilab"   # The URL will be kialilab.yourdomain.com
argo_rollouts_host = "argolab"    # The URL will be argolab.yourdomain.com
argocd_host        = "argocdlab"  # The URL will be argocdlab.yourdomain.com
