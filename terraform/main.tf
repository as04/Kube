terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.17.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "plivo-task"
  }
}

# resource "kubernetes_deployment" "dep" {
#   metadata {
#     name = "flask-app-deployment"
#     labels = {
#       app = "flask-app"
#     }
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
#           image = "my-flask-app:latest"
#           name  = "flask-app"
#           image_pull_policy = "IfNotPresent"

#         #   resources {
#         #     limits = {
#         #       cpu    = "0.5"
#         #       memory = "512Mi"
#         #     }
#         #     requests = {
#         #       cpu    = "250m"
#         #       memory = "50Mi"
#         #     }
#         #   }
#         }
#       }
#     }
#   }
# }

