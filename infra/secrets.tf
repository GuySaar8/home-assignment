# Database Password Generation

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$*()-_=+[]{}~"
}

# AWS Secrets Manager Secret
resource "aws_secretsmanager_secret" "rds_credentials" {
  name_prefix = "hello-world-${local.tags.Environment}-rds-"
  description = "RDS credentials for Hello World app"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = "hello_world_user"
    password = random_password.db_password.result
    engine   = "postgres"
    dbname   = "hello_world"
    port     = "5432"
    host     = module.db.db_instance_address
  })
}
