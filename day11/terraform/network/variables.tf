variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "The private subnet CIDR"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "The public subnet CIDR"
}

variable "databases_subnet_cidr" {
  type        = list(string)
  description = "The databases subnet CIDR"
}
