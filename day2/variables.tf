variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "alb_ingress_cidr_enabled" {
  type        = list(string)
  description = "A list of CIDR enabled to access the ALB"
}

variable "ecs" {
  type = object({
    nodes_ami           = string
    node_instance_type  = string
    node_volume_size_gb = number
    node_volume_type    = optional(string, "gp3")
    on_demand = object({
      desired_size = number
      min_size     = number
      max_size     = number
    })
    spot = object({
      desired_size = number
      min_size     = number
      max_size     = number
      max_price    = string
    })
  })
  description = "ECS sizing"
}
