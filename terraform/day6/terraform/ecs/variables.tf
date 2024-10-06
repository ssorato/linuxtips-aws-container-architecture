variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "capacity_providers" {
  type        = list(string)
  description = "A list of capacity providers used by ECS with Fargate"
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "alb_ingress_cidr_enabled" {
  type        = list(string)
  description = "A list of CIDR enabled to access the ALB"
  default     = ["auto"] # auto means uses the public ip of the host running terraform
}
