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
  description = "The AWS primary region"
}

variable "region_secondary" {
  type        = string
  description = "The AWS secondary region"
}

variable "acm_dns_name" {
  type        = string
  description = "The AWS Certificate Manager DNS name"
}

variable "route53_hosted_zone" {
  type        = string
  description = "The AWS Route53 domain hosted zone id"
}
