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
  region = var.region
}

provider "aws" {
  alias  = "peer"
  region = var.region_peer
}
