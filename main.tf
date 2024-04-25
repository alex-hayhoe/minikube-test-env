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
  source = "./namespace.tf"
}

module "mysql" {
  source = "./mysql.tf"
}

module "nginx" {
  source = "./nginx.tf"
}

module "minio" {
  source = "./minio.tf"
}