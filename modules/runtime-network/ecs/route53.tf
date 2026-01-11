# Aレコードの追加を行う

# ドメインは購入済み
# ホストゾーンも作成済み
# 残りはAレコードの追加

# ホストゾーンの取得
data "aws_route53_zone" "host_zone" {
    name = var.domain
}

# Aレコードの追加
resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.host_zone.id
  name    = "ecs.${var.domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.app_alb.dns_name
    zone_id                = data.aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}