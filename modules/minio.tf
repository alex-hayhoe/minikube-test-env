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