# Create a namespace for observability
resource "kubernetes_namespace" "observability-namespace" {
    metadata {
        name = var.monitoring_namespace
    }
    depends_on = [ module.eks ]
}

# Helm chart for Grafana
resource "helm_release" "grafana" {
    name             = "grafana"
    chart            = "grafana"
    version          = "7.1.0"
    repository       = var.grafana_helm_chart_repository
    namespace        = var.monitoring_namespace

    values = [file("${path.module}/values/grafana.yaml")]
    depends_on = [ kubernetes_namespace.observability-namespace ]
}

# Helm chart for Loki
resource "helm_release" "loki" {
    name       = "loki"
    chart      = "loki"
    version    = "5.41.5"
    repository = var.grafana_helm_chart_repository
    namespace  = var.monitoring_namespace

    values = [file("${path.module}/values/loki.yaml")]
    depends_on = [ kubernetes_namespace.observability-namespace ]
}

# Helm chart for promtail
resource "helm_release" "promtail" {
    name       = "promtail"
    chart      = "promtail"
    version    = "6.15.3"
    repository = var.grafana_helm_chart_repository
    namespace  = var.monitoring_namespace

    values = [file("${path.module}/values/promtail.yaml")]
    depends_on = [ kubernetes_namespace.observability-namespace ]
}

# Helm chart for Prometheus
resource "helm_release" "prometheus" {
    name       = "prometheus"
    chart      = "prometheus"
    version    = "25.8.2"
    repository = var.prometheus_helm_chart_repository
    namespace  = var.monitoring_namespace

    values     = [file("${path.module}/values/prometheus.yaml")]
    depends_on = [kubernetes_namespace.observability-namespace]
}

# Helm chart for Prometheus
resource "helm_release" "tempo-distributed" {
    name       = "tempo-distributed"
    chart      = "tempo-distributed"
    version    = "1.32.1"
    repository = var.grafana_helm_chart_repository
    namespace  = var.monitoring_namespace

    values     = [file("${path.module}/values/tempo-distributed.yaml")]
    depends_on = [kubernetes_namespace.observability-namespace]
}

# Helm chart for Mimir distributed
resource "helm_release" "mimir-distributed" {
    name       = "mimir-distributed"
    chart      = "mimir-distributed"
    version    = "4.4.1"
    repository = var.grafana_helm_chart_repository
    namespace  = var.monitoring_namespace

    values     = [file("${path.module}/values/mimir-distributed.yaml")]
    depends_on = [kubernetes_namespace.observability-namespace]
}