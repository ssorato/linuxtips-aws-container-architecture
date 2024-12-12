variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day12"
    app        = "ecs-health-api-lab"
  }
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
  default     = "linuxtips"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ssm_alb" {
  default = "/linuxtips/ecs/lb/arn"
}

variable "ssm_listener" {
  default = "/linuxtips/ecs/lb/listerner/arn"
}

variable "ssm_alb_internal" {
  default = "/linuxtips/ecs/lb/internal/arn"
}

variable "ssm_listener_internal" {
  default = "/linuxtips/ecs/lb/internal/listerner/arn"
}

variable "ssm_vpc_id" {
  default = "/linuxtips/vpc/vpc_id"
}

variable "ssm_private_subnet_1" {
  default = "/linuxtips/vpc/subnet_private_us_east_1a_id"
}

variable "ssm_private_subnet_2" {
  default = "/linuxtips/vpc/subnet_private_us_east_1b_id"
}

variable "ssm_private_subnet_3" {
  default = "/linuxtips/vpc/subnet_private_us_east_1c_id"
}

variable "ssm_service_discovery_namespace" {
  default = "/linuxtips/ecs/cloudmap/namespace"
}

### Service Connect
variable "ssm_service_connect_arn" {
  default = "/linuxtips/ecs/service-connect/namespace"
}

variable "ssm_service_connect_name" {
  default = "/linuxtips/ecs/service-connect/name"
}
