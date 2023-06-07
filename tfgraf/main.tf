terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana1"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "6.52.9"
  namespace  = "kube-public"

  values = [
    <<EOF
    service:
      type: NodePort
      port: 3000
      targetPort: 3000
      nodePort: 30000
    EOF
  ]

}

resource "helm_release" "prometheus" {
  name       = "prometheus1"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "15.3.0"
  namespace  = "kube-public"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "node_exporter" {
  name       = "node-exporter1"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-node-exporter"
  version    = "4.16"
  namespace  = "kube-public"
}
