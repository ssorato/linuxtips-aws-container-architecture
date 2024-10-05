common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "day2"
}
aws_region               = "us-east-1"
project_name             = "linuxtips"
alb_ingress_cidr_enabled = ["auto"] # auto means uses the public ip of the host running terraform
ecs = {
  nodes_ami           = "ami-09d3335e2eaf06692"
  node_instance_type  = "t3a.small" # 2 vCPU 2 GiB
  node_volume_size_gb = 30
  node_volume_type    = "gp3"
  on_demand = {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
  spot = {
    desired_size = 2
    min_size     = 1
    max_size     = 3
    max_price    = "0.0075"
  }
}