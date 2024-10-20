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

variable "ssm_alb_arn" {
  type        = string
  description = "The ALB arn from AWS Systems Manager Parameter Store"
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
    secrets = list(object({
      name : string
      valueFrom : string # ARN
    }))
    capabilities        = list(string)
    service_healthcheck = map(any)
    service_launch_type = list(object({
      capacity_provider = string
      weight            = number
    }))
    service_hosts = list(string)
  })
  description = "ECS service"
}

variable "common_scale" {
  type = object({
    scale_type   = string
    task_maximum = number
    task_minimum = number
    task_desired = number
    in_cooldown  = number
    out_cooldown = number
  })
  description = "Common scale parameters"
}

variable "cloudwatch_scale" {
  type = object({
    out_statistic           = string
    out_cpu_threshold       = number
    out_adjustment          = number
    out_comparison_operator = string
    out_period              = number
    out_evaluation_periods  = number
    in_statistic            = string
    in_cpu_threshold        = number
    in_adjustment           = number
    in_comparison_operator  = string
    in_period               = number
    in_evaluation_periods   = number
  })
  description = "Cloudwatch scale parameters"
}

variable "tracking_scale_cpu" {
  type        = number
  description = "Tracking scale using CPU percentage for the metric"
}

variable "tracking_scale_requests" {
  type        = number
  description = "Tracking scale using number of requests for the metric"
}

variable "container_image" {
  type        = string
  description = "The container image used by ECS application"
  default     = null
}

variable "efs_volumes" {
  type = list(object({
    volume_name : string
    file_system_root : string
    mount_point : string
    read_only : bool
  }))
  description = "EFS volume used in the ECS tasks"
}
