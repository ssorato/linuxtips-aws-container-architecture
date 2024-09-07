data "http" "my_public_ip" {
  url = "http://ifconfig.me"
}

module "ecs_ec2" {
  source = "../modules/ecs_ec2"

  common_tags = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
  }
  aws_region               = var.aws_region
  project_name             = "linuxtips"
  alb_ingress_cidr_enabled = ["${chomp(data.http.my_public_ip.response_body)}/32"] # limit access to the ALB from my public ip
  ecs = {
    nodes_ami           = "ami-0dc67873410203528"
    node_instance_type  = "t3a.medium"
    node_volume_size_gb = 30
    node_volume_type    = "gp3"
    on_demand = {
      desired_size        = 2
      min_size            = 1
      max_size            = 3
    }
    spot = {
      desired_size        = 2
      min_size            = 1
      max_size            = 3
      max_price           = "0.15"
    }
  }
}

output "ecs_alb" {
  value       = module.ecs_ec2.ecs_alb_dns_name
  description = "The ECS ALB dns name"
}