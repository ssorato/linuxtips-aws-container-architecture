variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "region_primary" {
  type        = string
  description = "The AWS primary region"
}

variable "region_secondary" {
  type        = string
  description = "The AWS secondary region"
}

variable "api_dns_name" {
  type        = string
  description = "The API dns name"
}

variable "route53_hosted_zone" {
  type        = string
  description = "The AWS Route53 domain hosted zone id"
}

variable "routing" {
  type = object({
    us-east-1 = number
    us-east-2 = number
  })
  description = "Route53 traffic routin; value is a percentage"
}
