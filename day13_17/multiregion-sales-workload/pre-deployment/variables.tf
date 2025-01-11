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

variable "active_states" {
  type = object({
    us-east-1 = string
    us-east-2 = string
  })
  description = "The region state (ACTIVE or PASSIVE)"
}

variable "dynamodb_idempotency" {
  type = object({
    name                   = string
    billing_mode           = string
    point_in_time_recovery = bool

    read_min                 = number
    read_max                 = number
    read_autoscale_threshold = number

    write_min                 = number
    write_max                 = number
    write_autoscale_threshold = number
  })
  description = "The DynamoDB idempotency db"
}

variable "dynamodb_sales" {
  type = object({
    name                   = string
    billing_mode           = string
    point_in_time_recovery = bool

    read_min                 = number
    read_max                 = number
    read_autoscale_threshold = number

    write_min                 = number
    write_max                 = number
    write_autoscale_threshold = number
  })
  description = "The DynamoDB sales db"
}

