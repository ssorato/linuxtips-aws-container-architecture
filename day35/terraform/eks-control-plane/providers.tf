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
  alias = "cluster-control-plane"
  host                   = module.eks-control-plane.eks_api_endpoint
  cluster_ca_certificate = module.eks-control-plane.cluster_ca_certificate
  token                  = module.eks-control-plane.k8s_token
}

provider "helm" {
  alias = "cluster-control-plane"
  kubernetes {
    host                   = module.eks-control-plane.eks_api_endpoint
    cluster_ca_certificate = module.eks-control-plane.cluster_ca_certificate
    token                  = module.eks-control-plane.k8s_token
  }
}

provider "kubectl" {
  alias = "cluster-control-plane"
  host                   = module.eks-control-plane.eks_api_endpoint
  cluster_ca_certificate = module.eks-control-plane.cluster_ca_certificate
  token                  = module.eks-control-plane.k8s_token
  load_config_file       = "false"
}
