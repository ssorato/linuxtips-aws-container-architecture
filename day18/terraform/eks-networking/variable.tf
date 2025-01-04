variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    created_by = "terraform-linuxtips-aws-container-architecture"
    sandbox    = "linuxtips"
    day        = "day18"
    step       = "eks-networking"
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

variable "vpc_cidr" {
  type    = string
  default = "The main VPC CIDR"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "Additional VPC CIDR's list"
}

variable "public_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The public subnet CIDR"
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The private subnet CIDR"
}

variable "database_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The databases subnet CIDR"
}

variable "database_nacl_rules" {
  type = list(object({
    rule_start_number = number
    rule_action       = string
    protocol          = string
    from_port         = optional(number)
    to_port           = optional(number)
  }))
  description = "A map of network ACLs rules in the database subnet"
}
