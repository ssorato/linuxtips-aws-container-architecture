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

variable "node_group" {
  type = map(object({
    capacity_type  = string
    ami_type       = optional(string, null)
    labels         = map(string)
    instance_sizes = list(string)
    min            = number
    max            = number
    desired        = number
  }))
  description = "Cluster node group and autoscaling configurations"
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

variable "istio_config" {
  type = object({
    version       = string
    min_replicas  = number
    cpu_threshold = number
  })
  description = "Istio Ingress Controller configurations"
}

variable "ingress_inbound_cidrs" {
  type        = list(string)
  description = "NLB used by ingress controller and TargetGroupBinding - CIDRs access"
  default     = ["0.0.0.0/0"]
}

variable "grafana_host" {
  type        = string
  description = "Grafana host"
}

variable "jaeger_host" {
  type        = string
  description = "Jaeger host"
}

variable "kiali_host" {
  type        = string
  description = "Kiali host"
}
