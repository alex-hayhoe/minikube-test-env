
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