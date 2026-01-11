# S3バケットの取り込み
# data "aws_s3_bucket" "app_bucket" {
#   # ここscriptsがscritpsになっているので後で修正する
#   bucket = "${var.project}-${var.environment}-${var.ver}-app-scritps"
# }

# secrets-managerの取り込み
data "aws_secretsmanager_secret" "rds_secret" {
  name = "${var.project}-${var.environment}-${var.ver}-secrets"
}

# data "aws_iam_openid_connect_provider" "github" {
#   url = "https://token.actions.githubusercontent.com"
# }