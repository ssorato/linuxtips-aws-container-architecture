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
  host                   = module.eks-keda.eks_api_endpoint
  cluster_ca_certificate = module.eks-keda.cluster_ca_certificate
  token                  = module.eks-keda.k8s_token
}

provider "helm" {
  kubernetes {
    host                   = module.eks-keda.eks_api_endpoint
    cluster_ca_certificate = module.eks-keda.cluster_ca_certificate
    token                  = module.eks-keda.k8s_token
  }
}

provider "kubectl" {
  host                   = module.eks-keda.eks_api_endpoint
  cluster_ca_certificate = module.eks-keda.cluster_ca_certificate
  token                  = module.eks-keda.k8s_token
  load_config_file       = "false"
}

