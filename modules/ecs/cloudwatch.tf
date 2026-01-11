# Cloudwatch関連

## ロググループ
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project}-${var.environment}-cwlog"
  retention_in_days = 3
}

## ログストリーム