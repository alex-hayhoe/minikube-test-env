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
  source = "./modules/namespace"
}

module "mysql" {
  source = "./modules/mysql"
}

module "nginx" {
  source = "./modules/nginx"
}

module "minio" {
  source = "./modules/minio"
}