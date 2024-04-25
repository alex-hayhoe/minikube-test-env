provider "kubernetes" {
  config_context_cluster   = "minikube"
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

module "namespace" {
  source = "./resources/namespace"
}

module "mysql" {
  source = "./resources/mysql"
}

module "nginx" {
  source = "./resources/nginx"
}

module "minio" {
  source = "./resources/minio"
}