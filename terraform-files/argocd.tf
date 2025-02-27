################################################################################
# ArgoCD namespace
################################################################################
resource "kubernetes_namespace_v1" "argocd_namespace" {
    metadata {
        name = var.argocd_namespace
    }
    depends_on = [ module.eks ]
}

################################################################################
# Deploy ArgoCD with Helm
################################################################################
resource "helm_release" "argocd" {
    name = var.argocd_deploy_name
    repository = var.argocd_helm_repo_url
    chart = var.argocd_helm_chart_name
    namespace = var.argocd_namespace
    cleanup_on_fail = true
    depends_on = [ helm_release.alb-controller, kubernetes_namespace_v1.argocd_namespace ]
    values = [file("${path.module}/values/argocd.yaml")]
}

################################################################################
# Ingress object for ArgoCD
################################################################################
resource "kubernetes_ingress_v1" "argocd_ingress" {
    metadata {
        name = "argocd-ingress"
        namespace = "argocd"
        annotations = {
        "alb.ingress.kubernetes.io/scheme" = "internet-facing"
        "alb.ingress.kubernetes.io/target-type" = "ip"
        }
    }
    spec {
        ingress_class_name = "alb"
        rule {
        http {
            path {
            path = "/"
            path_type = "Prefix"
            backend {
                service {
                name = "argocd-server"
                port {
                    number = 80
                }
                }
            }
            }
        }
        }
    }
    depends_on = [ helm_release.argocd, module.eks, module.lbc_role, module.vpc, kubernetes_namespace_v1.argocd_namespace ]
}


################################################################################
## Connect to GitHub repository
# Authenticate to repository with key pair, generate with
# ssh-keygen -t ed25519 -C poc-argocd -N '' -f argo
# Add private key (argo) to ArgoCD instance (read from file)
# Add public key (argo.pub) to the repository
################################################################################
resource "github_repository_deploy_key" "argocd_repo_deploykey" {
    title      = "argocd-connect"
    repository = "poc-argocd-gitops"
    key        = file("${path.module}/${github_argocd_private_key_file}")
    read_only  = "false"
}

resource "kubernetes_secret_v1" "ssh_key" {
    metadata {
        name      = "private-repo-ssh-key"
        namespace = kubernetes_namespace.argocd.id
        labels = {
        "argocd.argoproj.io/secret-type" = "repository"
        }
    }
    type = "Opaque"
    data = {
        "sshPrivateKey" = file("${path.module}/${github_argocd_private_key_file}")
        "type"          = "git"
        "url"           = "git@github.com:mygithubusername/poc-argocd-gitops.git"
        "name"          = "github"
        "project"       = "default"
    }
}



################################################################################
## ArgoCD-GitHub webhook
# auto sync trigger targeting the `main` branch
################################################################################
data "kubernetes_service" "argocd_server" {
    metadata {
        name      = "argocd-server"
        namespace = var.argocd_namespace
    }
}

resource "github_repository_webhook" "argocd" {
    repository = "gitops"
    configuration {
        url          = "https://${data.kubernetes_service.argocd_server.status.0.load_balancer.0.ingress.0.hostname}"
        content_type = "json"
        // The secrets to avoid ddos if argo link is exposed, its just a random texts
        secret       = "random-text-to-aviod-ddos-if-the-link-exposed"
        insecure_ssl = true
    }
    active = true
    events = ["push"]
    dynamic "filter" {
        for_each = ["main"]
        content {
            type  = "branch"
            value = filter.value
        }
    }
}