resource "kubernetes_service" "flask_app" {
  metadata {
    name      = "flask-app"
    namespace = "plivo-task"
  }

  spec {
    selector = {
      app = "flask-app"
    }

    port {
      protocol    = "TCP"
      port        = 80   # Expose the service on port 80
      target_port = 8000 # Forward traffic to container port 5000
    }
    type = "NodePort"
  }
}

resource "kubernetes_service" "mysql_service" {
  metadata {
    name      = "mysql-service"
    namespace = "plivo-task"
  }

  spec {
    selector = {
      app = "mysql-kube"
    }

    port {
      protocol    = "TCP"
      port        = 3306
      target_port = 3306
    }

    cluster_ip = null
  }
}