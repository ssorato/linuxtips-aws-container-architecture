variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "ssm_vpc_id" {
  type        = string
  description = "The VPC id in the AWS Systems Manager Parameter Store"
}

variable "ssm_private_subnet_list" {
  type        = list(string)
  description = "A list of private subnet id in the AWS Systems Manager Parameter Store"
}

variable "ssm_alb_listener_arn" {
  type        = string
  description = "The ALB listernet arn from AWS Systems Manager Parameter Store"
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
