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
  }

}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks-argo.eks_api_endpoint
  cluster_ca_certificate = module.eks-argo.cluster_ca_certificate
  token                  = module.eks-argo.k8s_token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks-argo.eks_api_endpoint
    cluster_ca_certificate = module.eks-argo.cluster_ca_certificate
    token                  = module.eks-argo.k8s_token
  }
}

provider "kubectl" {
  host                   = module.eks-argo.eks_api_endpoint
  cluster_ca_certificate = module.eks-argo.cluster_ca_certificate
  token                  = module.eks-argo.k8s_token
  load_config_file       = "false"
}

