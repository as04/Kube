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

module "app" {
  source = "./app"
}

module "db" {
  source = "./db"
}

module "alerts" {
  source = "./alerts"
}
