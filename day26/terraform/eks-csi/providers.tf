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
  host                   = module.esk-csi.eks_api_endpoint
  cluster_ca_certificate = module.esk-csi.cluster_ca_certificate
  token                  = module.esk-csi.k8s_token
}

provider "helm" {
  kubernetes {
    host                   = module.esk-csi.eks_api_endpoint
    cluster_ca_certificate = module.esk-csi.cluster_ca_certificate
    token                  = module.esk-csi.k8s_token
  }
}

provider "kubectl" {
  host                   = module.eks-csi.eks_api_endpoint
  cluster_ca_certificate = module.eks-csi.cluster_ca_certificate
  token                  = module.eks-csi.k8s_token
  load_config_file       = "false"
}
