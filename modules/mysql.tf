resource "kubernetes_persistent_volume_claim" "mysql_data" {
  metadata {
    name      = "mysql-pvc"
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



resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql-service"
    namespace = var.namespace_name
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      protocol    = "TCP"
      port        = 3306
      target_port = 3306
    }
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
            value = var.mysql_root_password
          }
          
          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_db_name
          }

          env {
            name  = "DB_USERNAME"
            value = var.mysql_username
          }

          env {
            name  = "DB_PASSWORD"
            value = var.mysql_root_password
          }

          port {
            container_port = 3306
          }

        
          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
           name = "mysql-data"
           persistent_volume_claim {
           claim_name = kubernetes_persistent_volume_claim.mysql_data.metadata[0].name
          }
        }
      }
    }
  }
}