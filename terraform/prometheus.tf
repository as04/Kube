# prometheus-config.tf
resource "kubernetes_config_map" "prometheus_config" {
  metadata {
    name      = "prometheus-config"
    namespace = "plivo-task"
  }

  data = {
    "prometheus.yml" = templatefile("${path.module}/prometheus-config.yml.tpl", {})
  }
}

# prometheus-deployment.tf
resource "kubernetes_deployment" "prometheus_deployment" {
  metadata {
    name      = "prometheus-deployment"
    namespace = "plivo-task"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }

      spec {
        container {
          name  = "prometheus"
          image = "prom/prometheus"
          port {
            container_port = 9090
          }
          volume_mount {
            name       = "prometheus-config"
            mount_path = "/etc/prometheus"
            read_only  = true
          }
        }

        volume {
          name = "prometheus-config"
          config_map {
            name = kubernetes_config_map.prometheus_config.metadata.0.name
          }
        }
      }
    }
  }
}

# prometheus-service.tf
resource "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus-service"
    namespace = "plivo-task"
  }

  spec {
    selector = {
      app = "prometheus"
    }

    port {
      port        = 80
      target_port = 9090
    }
  }
}
