resource "kubernetes_ingress_v1" "flask_ingress" {
  metadata {
    name      = "flask-ingress"
    namespace = "plivo-task"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "hello-world.info"  # Replace with your actual domain
      http {
        path {
          path = "/"
          backend {
            service{
                name = "flask-app"
                port {
                    number = 80
                }
            }
          }
        }
      }
    }
  }
}
