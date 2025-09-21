################################################################################
# Kubernetes Database Secrets
################################################################################

# Database secret for dev namespace
resource "kubernetes_secret" "db_secret_dev" {
  metadata {
    name      = "hello-world-db-secret"
    namespace = kubernetes_namespace.dev.metadata[0].name
    labels = {
      "app.kubernetes.io/name"       = "hello-world"
      "app.kubernetes.io/instance"   = "dev"
      "app.kubernetes.io/component"  = "database"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    DB_USER     = "hello_world_user"
    DB_PASSWORD = random_password.db_password.result
    DB_HOST     = module.db.db_instance_address
    DB_PORT     = "5432"
    DB_NAME     = "hello_world"
  }

  type = "Opaque"
}

# Database secret for prd namespace
resource "kubernetes_secret" "db_secret_prd" {
  metadata {
    name      = "hello-world-db-secret"
    namespace = kubernetes_namespace.prd.metadata[0].name
    labels = {
      "app.kubernetes.io/name"       = "hello-world"
      "app.kubernetes.io/instance"   = "prd"
      "app.kubernetes.io/component"  = "database"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    DB_USER     = "hello_world_user"
    DB_PASSWORD = random_password.db_password.result
    DB_HOST     = module.db.db_instance_address
    DB_PORT     = "5432"
    DB_NAME     = "hello_world"
  }

  type = "Opaque"
}
