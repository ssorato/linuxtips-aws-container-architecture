variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day24"
    step       = "eks-albc"
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

variable "ssm_public_subnets" {
  type        = list(string)
  description = "Public subnets from AWS SSM parameters"
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

variable "k8s_version" {
  type        = string
  description = "The kubernetes version"
  default     = "1.31"
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

variable "ingress_controller_config" {
  type = object({
    kind            = optional(string, "Deployment")
    min_replicas    = number
    max_replicas    = number
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
    fargate_ns      = optional(string, "")
  })
  description = "Ingress Controller configurations"
}

variable "ingress_nlb" {
  type = object({
    create        = bool
    ingress_type  = optional(string,"")
    inbound_cidrs = optional(list(string), ["0.0.0.0/0"])
  })
  description = "Create a NLB used by ingress controller and TargetGroupBinding"
}