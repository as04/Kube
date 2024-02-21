resource "kubernetes_config_map" "fluentd_config" {
  metadata {
    name      = "fluentdconf"
    namespace = "plivo-task"
  }

  data = {
    "fluent.conf" = templatefile("${path.module}/fluentd.conf.tpl", {})
  }
}