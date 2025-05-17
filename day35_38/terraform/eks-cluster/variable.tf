variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "dayXX"
    step       = "eks-xxxx"
  }
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
  default     = "linuxtips"
}

variable "region" {
  type        = string
  description = "The AWS region"
}

variable "ssm_vpc" {
  type    = string
  default = "The main VPC from AWS SSM parameters"
}

variable "ssm_private_subnets" {
  type        = list(string)
  description = "Private subnets from AWS SSM parameters"
}

variable "ssm_pod_subnets" {
  type        = list(string)
  description = "PODs subnets from AWS SSM parameters"
}

variable "ssm_natgw_eips" {
  type        = list(string)
  description = "NAT gw EIP from AWS SSM parameters"
}

variable "route53" {
  type = object({
    dns_name    = string
    hosted_zone = string
  })
  description = "Route53 dns name and hosted zone"
  default = {
    dns_name    = ""
    hosted_zone = ""
  }
}

variable "alb_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks that can access the shared load balancer"
  default     = ["0.0.0.0/0"]
}

variable "karpenter_capacity" {
  type = list(object({
    name               = string
    workload           = string
    ami_family         = string
    ami_ssm            = string
    instance_family    = list(string)
    instance_sizes     = list(string)
    capacity_type      = list(string)
    availability_zones = list(string)
  }))
}

variable "ssm_target_groups" {
  type        = list(string)
  description = "Shared load balancer taget groups from AWS SSM parameters"
}
