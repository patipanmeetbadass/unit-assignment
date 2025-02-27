################################################################################
# IRSA
# Create an IAM Role for Service Accounts (IRSA) to enable pod-level access
# Enable pod-level access with oidc_provider
################################################################################
data "aws_iam_policy" "ebs_csi_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
    version = "5.39.0"
    create_role                   = true
    role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
    provider_url                  = module.eks.oidc_provider
    role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
    oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    tags = {
        Environment = var.env_name
    }
}