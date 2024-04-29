resource "kubernetes_deployment" "laravel" {
  metadata {
    namespace = var.namespace_name
    name      = "laravel"
  }

  spec {
    replicas = var.laravel_replicas

    selector {
      match_labels = {
        app = "laravel"
      }
    }

    template {
      metadata {
        labels = {
          app = "laravel"
        }
      }

      spec {
        container {
          name  = "laravel"
          image = "lerufic/laravel:latest"

          env {
            name  = "APP_ENV"
            value = "production"
          }

          # Configure Laravel to use MySQL
          env {
            name  = "DB_CONNECTION"
            value = "mysql"
          }

          env {
            name  = "DB_HOST"
            value = "mysql-service"
          }

          env {
            name  = "DB_PORT"
            value = "3306"  # MySQL port
          }

          env {
            name  = "DB_DATABASE"
            value = var.mysql_db_name  # MySQL database name
          }

          env {
            name  = "DB_USERNAME"
            value = var.mysql_username  # MySQL username
          }

          env {
            name  = "DB_PASSWORD"
            value = var.mysql_root_password  # MySQL password
          }

          # Configure Laravel to use MinIO
          env {
            name  = "MINIO_ENDPOINT"
            value = "http://minio-service:9000"  # Assuming minio-service is the service name for MinIO
          }

          env {
            name  = "MINIO_ACCESS_KEY"
            value = var.minio_access_key
          }

          env {
            name  = "MINIO_SECRET_KEY"
            value = var.minio_secret_key
          }

          port {
            name           = "port1"
            container_port = 9000
            protocol       = "TCP" 
          }
        }
      }
    }
  }
}