variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day3"
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

variable "ecs_service" {
  type = object({
    name      = string
    port      = number
    cpu       = number
    memory_mb = number
    ecs_name  = string
    environment_variables = list(object({
      name : string
      value : string
    }))
    capabilities        = list(string)
    service_healthcheck = map(any)
    service_launch_type = string
    service_task_count  = number
    service_hosts       = list(string)
  })
  description = "ECS service"
}

variable "ssm_vpc_id" {
  type        = string
  description = "The VPC id in the AWS Systems Manager Parameter Store"
}

variable "ssm_private_subnet_list" {
  type        = list(string)
  description = "A list of private subnet id in the AWS Systems Manager Parameter Store"
  validation {
    condition     = length(var.ssm_private_subnet_list) > 0
    error_message = "Needs at least one private subnet"
  }
}

variable "ssm_alb_listener_arn" {
  type        = string
  description = "The ALB listernet arn from AWS Systems Manager Parameter Store"
}
