terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.29.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context_cluster   = "minikube"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace_name
  }
}