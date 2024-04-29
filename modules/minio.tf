resource "kubernetes_persistent_volume_claim" "minio_data" {
  metadata {
    name      = "minio-pvc"
    namespace = var.namespace_name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
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

          env {
            name  = "MINIO_ROOT_USER"
            value = "var.minio_user"
          }

          env {
            name  = "MINIO_ROOT_PASSWORD"
            value = "var.minio_user_password"
          }

          port {
            container_port = 9000
          }

          args = [
            "server",
            "/data"
          ]

          volume_mount {
            name       = "minio-data"
            mount_path = "/data"
          }
        }
      
        volume {
           name = "minio-data"
           persistent_volume_claim {
           claim_name = kubernetes_persistent_volume_claim.minio_data.metadata[0].name
        }
      }
    }
  }
}
}