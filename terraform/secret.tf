
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