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
            name  = "MYSQL_USER"
            value = var.mysql_username
          }          

          env {
            name  = "MYSQL_USER_PW"
            value = var.mysql_username_password
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

resource "kubernetes_job" "mysql-init" {
  metadata {
    name      = "mysql-init"
    namespace = var.namespace_name
  }

  spec {
    template {
      metadata {
        labels = {
          app = "mysql-init"
        }
      }

      spec {
        container {
          name  = "mysql-init"
          image = "mysql:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          }

          env {
            name  = "MYSQL_USER"
            value = var.mysql_username
          }          

          env {
            name  = "MYSQL_USER_PW"
            value = var.mysql_username_password
          }

          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_db_name
          }

          command = ["sh", "-c", "mysql -h mysql-service -P 3306 --protocol=tcp -uroot -p${var.mysql_root_password} -e 'CREATE DATABASE IF NOT EXISTS '${var.mysql_db_name}''"]        
        }
        restart_policy = "Never"
      }
    }
  }
}

resource "kubernetes_job" "mysql-init-user" {
  metadata {
    name      = "mysql-init-user"
    namespace = var.namespace_name
  }

  spec {
    template {
      metadata {
        labels = {
          app = "mysql-init-user"
        }
      }

      spec {
        container {
          name  = "mysql-init-user"
          image = "mysql:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          }

          env {
            name  = "MYSQL_USER"
            value = var.mysql_username
          }          

          env {
            name  = "MYSQL_USER_PW"
            value = var.mysql_username_password
          }

          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_db_name
          }
        
          command = ["sh", "-c", "mysql -h mysql-service -P 3306 --protocol=tcp -uroot -p${var.mysql_root_password} -e 'CREATE USER '${var.mysql_username}'@'localhost' IDENTIFIED WITH mysql_native_password BY ${var.mysql_username_password}'"]
        }
        restart_policy = "Never"
      }
    }
  }
}

resource "kubernetes_job" "mysql-init-user-priviledges" {
  metadata {
    name      = "mysql-init-user-priviledges"
    namespace = var.namespace_name
  }

  spec {
    template {
      metadata {
        labels = {
          app = "mysql-init-user-priviledges"
        }
      }

      spec {
        container {
          name  = "mysql-init-user-priviledges"
          image = "mysql:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          }

          env {
            name  = "MYSQL_USER"
            value = var.mysql_username
          }          

          env {
            name  = "MYSQL_USER_PW"
            value = var.mysql_username_password
          }

          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_db_name
          }
        
          command = ["sh", "-c", "mysql -h mysql-service -P 3306 --protocol=tcp -uroot -p${var.mysql_root_password} -e GRANT ALL PRIVILEGES ON ${var.mysql_db_name} TO ${var.mysql_username}@'localhost'"]
        }
        restart_policy = "Never"
      }
    }
  }
}
