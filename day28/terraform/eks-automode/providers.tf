terraform {

  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
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
  host                   = module.eks-automode.eks_api_endpoint
  cluster_ca_certificate = module.eks-automode.cluster_ca_certificate
  token                  = module.eks-automode.k8s_token
}

provider "helm" {
  kubernetes {
    host                   = module.eks-automode.eks_api_endpoint
    cluster_ca_certificate = module.eks-automode.cluster_ca_certificate
    token                  = module.eks-automode.k8s_token
  }
}

provider "kubectl" {
  host                   = module.eks-automode.eks_api_endpoint
  cluster_ca_certificate = module.eks-automode.cluster_ca_certificate
  token                  = module.eks-automode.k8s_token
  load_config_file       = "false"
}
