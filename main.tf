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
  source = "./namespace"
}

module "mysql" {
  source = "./mysql"
}

module "nginx" {
  source = "./nginx"
}

module "minio" {
  source = "./minio"
}