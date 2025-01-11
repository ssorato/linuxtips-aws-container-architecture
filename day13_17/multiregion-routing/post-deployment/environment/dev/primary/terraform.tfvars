common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "ecs-final-project-vpc"
  step       = "routing"
}

project_name = "sales-cluster"

region_primary   = "us-east-1"
region_secondary = "us-east-2"

nlb_arn_primary_ssm   = "/sales-cluster/vpc-link/arn"
nlb_arn_secondary_ssm = "/sales-cluster/vpc-link/arn"

routing = {
  primary   = 100
  secondary = 0
}

route53_hosted_zone = "your_hosted_zone_id"
dns_name            = "sales.yourdomain.com"
