terraform {
    required_version = ">= 1.7.0"
    required_providers {
        github = {
            source  = "integrations/github"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
    default_tags {
    tags = {
        env = var.env_name
    }
    }
}

provider "kubernetes" {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "aws"
        # This requires the awscli to be installed locally where Terraform is executed
        args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
}

provider "helm" {
    kubernetes {
        host = module.eks.cluster_endpoint
        config_path = "~/.kube/config"
        cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
            command     = "aws"
        }
    }
}

provider "github" {
    token = var.github_personal_access_token
    owner = var.github_username
}