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

variable "region_peer" {
  type        = string
  description = "The AWS peer region"
}

variable "vpc_ssm" {
  type        = string
  description = "The vpc id arn from AWS Systems Manager Parameter Store"
}

variable "vpc_ssm_peer" {
  type        = string
  description = "The vpc peer id arn from AWS Systems Manager Parameter Store"
}