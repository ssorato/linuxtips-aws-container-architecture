terraform {

  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
  }

}

provider "aws" {
  region = var.aws_region
}
