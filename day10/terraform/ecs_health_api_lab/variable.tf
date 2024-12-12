variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day10"
    app        = "ecs-health-api-lab"
  }
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
  default     = "linuxtips"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ssm_alb" {
  type    = string
  default = "/linuxtips/ecs/lb/arn"
}

variable "ssm_listener" {
  type    = string
  default = "/linuxtips/ecs/lb/listerner/arn"
}

variable "ssm_alb_internal" {
  type    = string
  default = "/linuxtips/ecs/lb/internal/arn"
}

variable "ssm_listener_internal" {
  type    = string
  default = "/linuxtips/ecs/lb/internal/listerner/arn"
}

variable "ssm_vpc_id" {
  type    = string
  default = "/linuxtips/vpc/vpc_id"
}

variable "ssm_private_subnet_1" {
  type    = string
  default = "/linuxtips/vpc/subnet_private_us_east_1a_id"
}

variable "ssm_private_subnet_2" {
  type    = string
  default = "/linuxtips/vpc/subnet_private_us_east_1b_id"
}

variable "ssm_private_subnet_3" {
  type    = string
  default = "/linuxtips/vpc/subnet_private_us_east_1c_id"
}

variable "ssm_service_discovery_namespace" {
  type    = string
  default = "/linuxtips/ecs/cloudmap/namespace"
}

### Service Connect
variable "ssm_service_connect_arn" {
  type    = string
  default = "/linuxtips/ecs/service-connect/namespace"
}

variable "ssm_service_connect_name" {
  type    = string
  default = "/linuxtips/ecs/service-connect/name"
}
