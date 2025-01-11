variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "region" {
  type        = string
  description = "The AWS region"
}

variable "dns_name" {
  type        = string
  description = "The domain name"
}

variable "route53_hosted_zone" {
  type        = string
  description = "The AWS Route53 domain hosted zone id"
}

variable "vpc_link_ssm" {
  type        = string
  description = "AWS SSM parameter store VPC link id"
}