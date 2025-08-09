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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
  }

}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  alias = "observability"
  host                   = module.eks-observability.eks_api_endpoint
  cluster_ca_certificate = module.eks-observability.cluster_ca_certificate
  token                  = module.eks-observability.k8s_token
}

provider "helm" {
  alias = "observability"
  kubernetes = {
    host                   = module.eks-observability.eks_api_endpoint
    cluster_ca_certificate = module.eks-observability.cluster_ca_certificate
    token                  = module.eks-observability.k8s_token
  }
}

provider "kubectl" {
  alias = "observability"
  host                   = module.eks-observability.eks_api_endpoint
  cluster_ca_certificate = module.eks-observability.cluster_ca_certificate
  token                  = module.eks-observability.k8s_token
  load_config_file       = false
}
