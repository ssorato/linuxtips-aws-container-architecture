common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  project    = "ecs-final-project"
  step       = "multiregion-sales-api-gateway"
}

project_name = "sales-api"
region       = "us-east-2"

dns_name            = "api.yourdomain.com"
route53_hosted_zone = "your_hosted_zone_id"

vpc_link_ssm = "/sales-cluster/vpc-link/id"

