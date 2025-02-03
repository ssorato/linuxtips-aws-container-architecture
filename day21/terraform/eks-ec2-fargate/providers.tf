terraform {

  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
    assert = {
      source = "hashicorp/assert"
    }
  }

}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.esk-vanilla.eks_api_endpoint
  cluster_ca_certificate = module.esk-vanilla.cluster_ca_certificate
  token                  = module.esk-vanilla.k8s_token
}

provider "helm" {
  kubernetes {
    host                   = module.esk-vanilla.eks_api_endpoint
    cluster_ca_certificate = module.esk-vanilla.cluster_ca_certificate
    token                  = module.esk-vanilla.k8s_token
  }
}
