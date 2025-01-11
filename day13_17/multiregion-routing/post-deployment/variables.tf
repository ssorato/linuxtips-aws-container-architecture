variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "region_primary" {
  type        = string
  description = "The primary AWS region"
}

variable "region_secondary" {
  type        = string
  description = "The secondary AWS region"
}

variable "nlb_arn_primary_ssm" {
  type        = string
  description = "The primary NLB arm from the AWS Systems Manager Parameter Store"
}

variable "nlb_arn_secondary_ssm" {
  type        = string
  description = "The secondary NLB arm from the AWS Systems Manager Parameter Store"
}

variable "routing" {
  type = object({
    primary   = number
    secondary = number
  })
  description = "Routing ??"
}

variable "route53_hosted_zone" {
  type        = string
  description = "The AWS Route53 hosted zone id"
}

variable "dns_name" {
  type        = string
  description = "The public domain name"
}
