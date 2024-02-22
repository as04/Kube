# prometheus-config.tpl
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
  - job_name: 'fluentd'
    static_configs:
      - targets: ['localhost:24220']
