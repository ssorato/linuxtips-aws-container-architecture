variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "ecs_service_name" {
  type        = string
  description = "The name of the ECS service"
}

variable "ecs_service_port" {
  type        = number
  description = "The port of the ECS service"
}

# can be set as string? https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size
# For example, you can specify a CPU value either as 1024 in CPU units or 1 vCPU in vCPUs.
# When the task definition is registered, a vCPU value is converted to an integer indicating the CPU units.
variable "ecs_service_cpu" {
  type        = number
  description = "The hard limit of CPU units to present for the task"
}

# can be set as string? default is in MiB
variable "ecs_service_memory_mb" {
  type        = number
  description = "The hard limit of memory, in MiB, to present to the task"
}

variable "ecs_name" {
  type        = string
  description = "The ECS cluster name"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnet list"
}

variable "alb_listener_arn" {
  type        = string
  description = "The ALB listener arn"
}

variable "service_task_execution_role_arn" {
  type        = string
  description = "The IAM task execution role arn"
}

variable "environment_variables" {
  type = list(object({
    name : string
    value : string
  }))
  description = "Environment variables used by ECS service"
  default     = []
}

variable "capabilities" {
  type        = list(string)
  description = "Capacity list like EC2 or FARGATE"
  default     = []
}
