# このリソースについては, 既存リソースを利用するのでコメントアウト
# 各自事前に作成しておくこと

# # ホストゾーンの作成
# resource "aws_route53_zone" "route53_zone" {
#   name          = var.domain
#   force_destroy = false

#   tags = {
#     Name    = "${var.project}-${var.environment}-${var.ver}-domain"
#     Project = var.project
#     Env     = var.environment
#   }
# }