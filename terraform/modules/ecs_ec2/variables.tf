variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day2"
  }
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
  default     = "linuxtips"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "ssm_vpc_id" {
  type        = string
  description = "The VPC id in the AWS Systems Manager Parameter Store"
  default     = "/linuxtips/vpc/vpc_id"
}

variable "ssm_private_subnet_list" {
  type        = list(string)
  description = "A list of private subnet id in the AWS Systems Manager Parameter Store"
  default = [
    "/linuxtips/vpc/subnet_private_us_east_1a_id",
    "/linuxtips/vpc/subnet_private_us_east_1b_id",
    "/linuxtips/vpc/subnet_private_us_east_1c_id"
  ]
  validation {
    condition     = length(var.ssm_private_subnet_list) > 0
    error_message = "Needs at least one private subnet"
  }
}

variable "ssm_public_subnet_list" {
  type        = list(string)
  description = "A list of public subnet id in the AWS Systems Manager Parameter Store"
  default = [
    "/linuxtips/vpc/subnet_public_us_east_1a_id",
    "/linuxtips/vpc/subnet_public_us_east_1b_id",
    "/linuxtips/vpc/subnet_public_us_east_1c_id"
  ]
  validation {
    condition     = length(var.ssm_public_subnet_list) > 0
    error_message = "Needs at least one public subnet"
  }
}

variable "alb_ingress_cidr_enabled" {
  type        = list(string)
  description = "A list of CIDR enabled to access the ALB"
  default     = ["0.0.0.0/0"]
  validation {
    condition     = length(var.alb_ingress_cidr_enabled) > 0
    error_message = "Needs at least one CIDR"
  }
}

# variable "ecs_on_demand" {
#   type = object({
#     desired_size        = number
#     min_size            = number
#     max_size            = number
#     nodes_ami           = string
#     node_instance_type  = string
#     node_volume_size_gb = number
#     node_volume_type    = optional(string, "gp3")
#   })
#   description = "ECS on-demand ec2 sizing"
# }

# variable "ecs_spot" {
#   type = object({
#     desired_size        = number
#     min_size            = number
#     max_size            = number
#     nodes_ami           = string
#     node_instance_type  = string
#     max_price           = string
#   })
#   description = "ECS spot ec2 sizing"
# }

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