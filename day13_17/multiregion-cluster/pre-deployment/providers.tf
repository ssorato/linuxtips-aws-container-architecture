terraform {

  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }
  }

}

provider "aws" {
  region = var.region_primary
}

provider "aws" {
  alias  = "secondary"
  region = var.region_secondary
}