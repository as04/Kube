
resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "plivo-task"
  }

  data = {
    root-password = base64encode("admin")
    database-name = base64encode("messages_db")
    user          = base64encode("root")
    password      = base64encode("admin")
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

resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name      = "mysql-kube"
    namespace = "plivo-task"
  }

  spec {
    service_name = "mysql-service"

    replicas = 1

    selector {
      match_labels = {
        app = "mysql-kube"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql-kube"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:latest"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = kubernetes_secret.mysql_secret.data["root-password"]
          }
          env {
            name  = "MYSQL_DATABASE"
            value = kubernetes_secret.mysql_secret.data["database-name"]
          }
          env {
            name  = "MYSQL_USER"
            value = kubernetes_secret.mysql_secret.data["user"]
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = kubernetes_secret.mysql_secret.data["password"]
          }

          port {
            container_port = 3306
          }

          volume_mount {
            name       = "mysql-storage"
            mount_path = "/var/lib/mysql"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "mysql-storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }

        storage_class_name = "standard" # Use the appropriate storage class
      }
    }
  }
}


data "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "plivo-task"
  }
}