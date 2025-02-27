################################################################################
# Environment
################################################################################
variable "env_name" {
    type = string
    default = "poc"
}

################################################################################
# Credentials
################################################################################
variable "github_personal_access_token" {
    type = string
    default = "ghp_example_github_personal_access_token"
}
variable "github_username" {
    type = string
    default = "github_example_username"
}
variable "github_argocd_private_key_file" {
    type = string
    default = "credentials/argocd-private-key.key"
}


################################################################################
# Region and zone
################################################################################
variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "ap-southeast-7"
}

variable "aws_availability_zones" {
    description = "AWS availability zones"
    type        = string
    default     = "ap-southeast-7a"
}


################################################################################
# ArgoCD
################################################################################
variable "argocd_deploy_name" {
    type = string
    default = "argocd"
}
variable "argocd_helm_chart_name" {
    type = string
    default = "argo-cd"
}
variable "argocd_helm_repo_url" {
    type = string
    default = "https://argoproj.github.io/argo-helm"
}
variable "argocd_namespace" {
    type = string
    default = "argocd"
}
variable "argocd_server_insecure" {
    type = bool
    default = true
}


################################################################################
# AWS ALB Controller
################################################################################
variable "alb_controller_deploy_name" {
    type = string
    default = "aws-load-balancer-controller"
}

variable "alb_controller_helm_chart_name" {
    type = string
    default = "aws-load-balancer-controller"
}

variable "alb_controller_helm_repo_url" {
    type = string
    default = "https://aws.github.io/eks-charts"
}

variable "alb_controller_target_namespace" {
    type = string
    default = "kube-system"
}

################################################################################
# Monitoring
################################################################################
variable "monitoring_namespace" {
    type = string
    default = "monitoring"
}
variable "grafana_helm_chart_repository" {
    type = string
    default = "https://grafana.github.io/helm-charts"
}
variable "grafana_helm_chart_repository" {
    type = string
    default = "https://grafana.github.io/helm-charts"
}
variable "prometheus_helm_chart_repository" {
    type = string
    default = "https://prometheus-community.github.io/helm-charts"
}