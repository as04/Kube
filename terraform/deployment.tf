# resource "kubernetes_deployment" "dep" {
#   metadata {
#     name      = "flask-app-deployment"
#     namespace = "plivo-task"
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "flask-app"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "flask-app"
#         }
#       }

#       spec {
#         container {
#           image             = "my-flask-app:v4"
#           name              = "flask-app"
#           image_pull_policy = "IfNotPresent"

#           # Define environment variables
#           env {
#             name  = "DB_HOST"
#             value = "mysql-service"
#           }
#           env {
#             name = "DB_USER"
#             value_from {
#               secret_key_ref {
#                 name = "mysql-secret"
#                 key  = "user"
#               }
#             }
#           }
#           env {
#             name = "DB_PASSWORD"
#             value_from {
#               secret_key_ref {
#                 name = "mysql-secret"
#                 key  = "password"
#               }
#             }
#           }
#           env {
#             name = "DB_NAME"
#             value_from {
#               secret_key_ref {
#                 name = "mysql-secret"
#                 key  = "database-name"
#               }
#             }
#           }
#           env {
#             name  = "DB_PORT"
#             value = "3306"
#           }

#           # Define readiness probe
#           readiness_probe {
#             http_get {
#               path = "/"
#               port = 8000
#             }
#             initial_delay_seconds = 5
#             period_seconds        = 5
#             success_threshold     = 1
#           }

#           # Volume mount for logs
#           volume_mount {
#             name       = "log-volume"
#             mount_path = "/logs"
#           }
#         }

#         # Add Fluentd sidecar container
#         container {
#           name  = "fluentd-sidecar"
#           image = "fluent/fluentd:v1.12-debian"
#           image_pull_policy = "IfNotPresent"

#           volume_mount {
#             name       = "log-volume"
#             mount_path = "/logs"
#           }
#         }

#         # Define volumes
#         volume {
#           name = "log-volume"
#           empty_dir {}
#         }
#       }
#     }
#   }
# }

resource "kubernetes_deployment" "dep" {
  metadata {
    name      = "flask-app-deployment"
    namespace = "plivo-task"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "flask-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask-app"
        }
      }

      spec {
        container {
          name              = "flask-app"
          image             = "my-flask-app:v4"
          image_pull_policy = "IfNotPresent"

          # Define environment variables
          env {
            name  = "DB_HOST"
            value = "mysql-service"
          }
          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "user"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "password"
              }
            }
          }
          env {
            name = "DB_NAME"
            value_from {
              secret_key_ref {
                name = "mysql-secret"
                key  = "database-name"
              }
            }
          }
          env {
            name  = "DB_PORT"
            value = "3306"
          }

          # Define readiness probe
          readiness_probe {
            http_get {
              path = "/"
              port = 8000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            success_threshold     = 1
          }

          # Volume mount for logs
          volume_mount {
            name       = "log-volume"
            mount_path = "/logs"
          }
        }

        # Add Fluentd sidecar container
        container {
          name  = "fluentd-sidecar"
          image = "fluent/fluentd:v1.12-debian"
          image_pull_policy = "IfNotPresent"

          volume_mount {
            name       = "log-volume"
            mount_path = "/logs"
          }

          volume_mount {
            name       = "fluentd-config"
            mount_path = "/fluentd/etc"
          }
        }

        # Define volumes
        volume {
          name = "log-volume"
          empty_dir {}
        }

        volume {
          name = "fluentd-config"
          config_map {
            name = kubernetes_config_map.fluentd_config.metadata[0].name
          }
        }
      }
    }
  }
}

