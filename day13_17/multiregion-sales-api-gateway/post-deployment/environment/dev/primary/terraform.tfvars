common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "ecs-final-project-vpc"
  step       = "multiregion-sales-api-gateway"
}

region_primary   = "us-east-1"
region_secondary = "us-east-2"

api_dns_name        = "api.yourdomain.com"
route53_hosted_zone = "your_hosted_zone_id"

routing = {
  us-east-1 = 100
  us-east-2 = 0
}
