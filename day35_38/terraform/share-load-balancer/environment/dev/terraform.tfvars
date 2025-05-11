common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day35_38"
  step       = "shared-load-balancer"
}

project_name = "linuxtips-ingress"
region       = "us-east-1"

ssm_vpc = "/linuxtips-vpc/vpc/id"
ssm_public_subnets = [
  "/linuxtips-vpc/subnets/public/us-east-1a/linuxtips-public-1a",
  "/linuxtips-vpc/subnets/public/us-east-1b/linuxtips-public-1b",
  "/linuxtips-vpc/subnets/public/us-east-1c/linuxtips-public-1c"
]

# route53 = {
#   dns_name    = "*.yourdomain.com" # use a wild-card due to multiple subdomains
#   hosted_zone = "YOURHOSTEDZONEID"
# }

routing_weight = {
  cluster_01 = 100
  cluster_02 = 0
}
