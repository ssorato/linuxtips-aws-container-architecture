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

variable "bucket_prefix_name" {
  type        = string
  description = "The S3 bucket prefix name"
}

variable "sqs_sns_name" {
  type        = string
  description = "The queue/topic name"
}
