resource "kubernetes_persistent_volume_claim" "mysql_data" {
  metadata {
    name      = "mysql-pvc"
    namespace = var.namespace_name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
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

resource "kubernetes_pod" "mysql-init" {
  metadata {
    name      = "mysql-init"
    namespace = var.namespace_name
  }

  spec {
    init_container {
      name  = "init-mysql"
      image = "mysql:latest"

      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = var.mysql_root_password
      }

      env {
        name  = "MYSQL_DATABASE"
        value = var.mysql_db_name
      }

      volume_mount {
        name       = "mysql-data"
        mount_path = "/var/lib/mysql"
      }

      command = ["sh", "-c", "mysql -h localhost -uroot -p${var.mysql_root_password} -e 'CREATE DATABASE IF NOT EXISTS ${var.mysql_db_name}'"]
    }

    container {
      name  = "mysql"
      image = "mysql:latest"

      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = var.mysql_root_password
      }

      ports {
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