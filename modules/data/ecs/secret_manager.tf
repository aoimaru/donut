# 実際の値を格納
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    SOLA_DB_USER       = "developer",
    SOLA_DB_PASSWORD   = random_password.initial_password.result,
    ENGINE             = "postgres",
    SOLA_DB_HOST       = aws_db_instance.postgresql_standalone.endpoint,
    SOLA_DB_NAME       = "main",
    SOLA_DB_PORT       = 5432,
  })
}
