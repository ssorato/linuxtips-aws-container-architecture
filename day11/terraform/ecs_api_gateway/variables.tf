variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day11"
    app        = "ecs-api-gateway"
  }
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "vpc_link" {
  type        = string
  description = "The VPC link id used by the API Gateway"
}

variable "environment" {
  description = "The infrastructure environment"
  type        = string
}

