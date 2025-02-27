################################################################################
# Network
################################################################################
output "vpc_id" {
    value = module.vpc.vpc_id
}

################################################################################
# EKS
################################################################################
output "eks_cluster_id" {
    description = "EKS cluster ID"
    value = module.eks.cluster_id
}
output "cluster_endpoint" {
    description = "Endpoint for EKS control plane"
    value       = module.eks.cluster_endpoint
}
output "cluster_security_group_id" {
    description = "Security group ids attached to the cluster control plane"
    value       = module.eks.cluster_security_group_id
}
output "region" {
    description = "AWS region"
    value       = var.aws_region
}
output "cluster_name" {
    description = "Kubernetes Cluster Name"
    value       = module.eks.cluster_name
}

################################################################################
# IAM Role for Service Accounts (IRSA)
################################################################################
output "irsa_role_name" {
    description = "EKS cluster ID"
    value = mmodule.irsa-ebs-csi.role_name
}
output "irsa_role_policy_arns" {
    description = "EKS cluster ID"
    value = mmodule.role_policy_arns
}