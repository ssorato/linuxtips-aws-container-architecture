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

variable "ssm_public_subnets" {
  type        = list(string)
  description = "A list of public subnet id from the AWS Systems Manager Parameter Store"
}

variable "ssh_public_key_file" {
  type        = string
  description = "The ssh public key file path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "enable_bastion" {
  type        = bool
  description = "Create the VM bastion to access to the private subnet"
  default     = false
}