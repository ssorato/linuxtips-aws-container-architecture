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
  alias = "cluster01"
  host                   = module.eks-cluster01.eks_api_endpoint
  cluster_ca_certificate = module.eks-cluster01.cluster_ca_certificate
  token                  = module.eks-cluster01.k8s_token
}

provider "helm" {
  alias = "cluster01"
  kubernetes {
    host                   = module.eks-cluster01.eks_api_endpoint
    cluster_ca_certificate = module.eks-cluster01.cluster_ca_certificate
    token                  = module.eks-cluster01.k8s_token
  }
}

provider "kubectl" {
  alias = "cluster01"
  host                   = module.eks-cluster01.eks_api_endpoint
  cluster_ca_certificate = module.eks-cluster01.cluster_ca_certificate
  token                  = module.eks-cluster01.k8s_token
  load_config_file       = "false"
}

provider "kubernetes" {
  alias = "cluster02"
  host                   = module.eks-cluster02.eks_api_endpoint
  cluster_ca_certificate = module.eks-cluster02.cluster_ca_certificate
  token                  = module.eks-cluster02.k8s_token
}

provider "helm" {
  alias = "cluster02"
  kubernetes {
    host                   = module.eks-cluster02.eks_api_endpoint
    cluster_ca_certificate = module.eks-cluster02.cluster_ca_certificate
    token                  = module.eks-cluster02.k8s_token
  }
}

provider "kubectl" {
  alias = "cluster02"
  host                   = module.eks-cluster02.eks_api_endpoint
  cluster_ca_certificate = module.eks-cluster02.cluster_ca_certificate
  token                  = module.eks-cluster02.k8s_token
  load_config_file       = "false"
}
