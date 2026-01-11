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
    # JWT_SECRET         = filebase64("./cert/private.key"),
    # JWT_PUBLIC         = filebase64("./cert/public.key"),
    # JWT_REFRESH_SECRET = filebase64("./cert/privateref.key"),
    # JWT_REFRESH_PUBLIC = filebase64("./cert/publicref.key"),
    JWT_SECRET         = var.jwt_private_key_base64,
    JWT_PUBLIC         = var.jwt_public_key_base64,
    JWT_REFRESH_SECRET = var.jwt_refresh_private_key_base64,
    JWT_REFRESH_PUBLIC = var.jwt_refresh_public_key_base64,
  })
}
