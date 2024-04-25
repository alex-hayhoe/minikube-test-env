provider "kubernetes" {
  config_context_cluster   = "minikube"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace_name
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    namespace = var.namespace_name
    name      = "mysql"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "var.mysql_root_password"
          }

          port {
            container_port = 3306
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    namespace = var.namespace_name
    name      = "nginx"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "minio" {
  metadata {
    namespace = var.namespace_name
    name      = "minio"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "minio"
      }
    }

    template {
      metadata {
        labels = {
          app = "minio"
        }
      }

      spec {
        container {
          name  = "minio"
          image = "minio/minio:latest"

          env {
            name  = "MINIO_ACCESS_KEY"
            value = "var.minio_access_key"
          }

          env {
            name  = "MINIO_SECRET_KEY"
            value = "var.minio_secret_key"
          }

          port {
            container_port = 9000
          }

          args = [
            "server",
            "/data"
          ]

          volume_mount {
            name       = "minio-storage"
            mount_path = "/data"
          }
        }

        volume {
          name = "minio-storage"
          empty_dir {}
        }
      }
    }
  }
}