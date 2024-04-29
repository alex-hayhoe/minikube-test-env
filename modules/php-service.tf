resource "kubernetes_service" "php" {
  metadata {
    namespace = var.namespace_name
    name = "laravel"

    labels = {
      app = "laravel"
    }
  }

  spec {
    port {
      name     = "phpfpm"
      protocol = "TCP"
      port     = 9000
    }

    selector = {
      app = "laravel"
    }
  }
}

