variable "common_tags" {
  type          = map(string)
  description   = "Common tags"
  default       = {
    created_by  = "terraform-linuxtips-aws-container-architecture"
    sandbox     = "linuxtips"
    day         = "day1"
  }
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
  default     = "linuxtips"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR"
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC must be a valid IPv4 CIDR."
  }
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "The private subnet CIDR"
  default     = ["10.0.0.0/20","10.0.16.0/20","10.0.32.0/20"]
  validation {
    condition = length(var.private_subnet_cidr) > 0 && alltrue([
      for cidr in var.private_subnet_cidr : can(cidrhost(cidr, 0))
    ])
    error_message = "Needs at least one private subnet and it must be a valid IPv4 CIDR."
  }
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "The public subnet CIDR"
  default     = ["10.0.48.0/24","10.0.49.0/24","10.0.50.0/24"]
  validation {
    condition = length(var.public_subnet_cidr) > 0 && alltrue([
      for cidr in var.public_subnet_cidr : can(cidrhost(cidr, 0))
    ])
    error_message = "Needs at least one public subnet and it must be a valid IPv4 CIDR."
  }
}

variable "databases_subnet_cidr" {
  type        = list(string)
  description = "The databases subnet CIDR"
  default     = ["10.0.51.0/24","10.0.52.0/24","10.0.53.0/24"]
  validation {
    condition = length(var.databases_subnet_cidr) > 0 && alltrue([
      for cidr in var.databases_subnet_cidr : can(cidrhost(cidr, 0))
    ])
    error_message = "Needs at least one database subnet and must be a valid IPv4 CIDR."
  }
}
