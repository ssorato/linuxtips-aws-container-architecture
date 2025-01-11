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

variable "ssm_vpc_id" {
  type        = string
  description = "The VPC id from the AWS Systems Manager Parameter Store"
}

variable "ssm_private_subnets" {
  type        = list(string)
  description = "A list of private subnet id from the AWS Systems Manager Parameter Store"
}

variable "ssm_public_subnets" {
  type        = list(string)
  description = "A list of public subnet id from the AWS Systems Manager Parameter Store"
}

variable "acm_dns_certs" {
  type        = list(string)
  description = "A list of AWS Certificate Manager ARNs"
}
