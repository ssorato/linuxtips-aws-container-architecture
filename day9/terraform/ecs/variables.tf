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

variable "ssm_vpc_id" {
  type        = string
  description = "The VPC id in the AWS Systems Manager Parameter Store"
}

variable "ssm_public_subnet_list" {
  type        = list(string)
  description = "A list of public subnet id in the AWS Systems Manager Parameter Store"
}

variable "ssm_private_subnet_list" {
  type        = list(string)
  description = "A list of private subnet id in the AWS Systems Manager Parameter Store"
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

variable "ssh_public_key_file" {
  type        = string
  description = "The ssh public key file path"
  default     = "~/.ssh/id_rsa.pub"
}
