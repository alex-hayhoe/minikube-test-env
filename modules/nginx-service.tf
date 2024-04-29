resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
    namespace = var.namespace_name

    labels = {
      app = "nginx"
    }
  }

  spec {
    port {
      name      = "httpport"
      protocol  = "TCP"
      port      = 80
      node_port = var.NodePort_httpport
    }

    port {
      name      = "httpsport"
      protocol  = "TCP"
      port      = 443
      node_port = var.NodePort_httpsport
    }

    selector = {
      app = "nginx"
    }

    type = "NodePort"
  }
}

