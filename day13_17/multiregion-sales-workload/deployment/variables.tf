variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "region" {
  type        = string
  description = "The AWS region"
}

variable "sqs_processing_sales_config" {
  type = object({
    queue_name                    = string
    delay_seconds                 = number
    max_message_size              = number
    message_retention_seconds     = number
    receive_wait_time_seconds     = number
    visibility_timeout_seconds    = number
    dlq_redrive_max_receive_count = number
  })
}

variable "bucket_prefix_name" {
  type = string
}

variable "sales_idempotency_table_name" {
  type        = string
  description = "The DynamoDB table used in the idempotency"
}

variable "sales_table_name" {
  type        = string
  description = "The DynamoDB table used to store sales"
}

variable "parameter_store_state_name" {
  type        = string
  description = "The AWS SSM parameter store with region state (ACTIVE or PASSIVE)"
}

variable "ssm_vpc_id" {
  type        = string
  description = "The AWS SSM parameter store with VPC id"
}

variable "ssm_private_subnet_1" {
  type        = string
  description = "The AWS SSM parameter store with first private subnet id"
}

variable "ssm_private_subnet_2" {
  type        = string
  description = "The AWS SSM parameter store with second private subnet id"
}

variable "ssm_private_subnet_3" {
  type        = string
  description = "The AWS SSM parameter store with third private subnet id"
}

variable "ssm_alb" {
  type        = string
  description = "The AWS SSM parameter store with ALB"
}

variable "ssm_listener" {
  type        = string
  description = "The AWS SSM parameter store with ALB listner"
}

variable "ssm_listener_https" {
  type        = string
  description = "The AWS SSM parameter store with ALB https listnet"
}

variable "cluster_name" {
  type        = string
  description = "The ECS cluster name"
}


variable "sales_dns_name" {
  type        = string
  description = "The Sales dns name"
}
