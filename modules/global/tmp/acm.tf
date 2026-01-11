# このリソースについては, 既存リソースを利用するのでコメントアウト
# 各自事前に作成しておくこと

# ここら辺はterraformの管理外でいいかも


# ## 証明書の作成
# resource "aws_acm_certificate" "tokyo_cert" {
#   domain_name = "*.${var.domain}"
#   # DNS検証
#   # ドメインを本当に持っているか？ということを検証する必要がああるので
#   # DNS検証となっている
#   validation_method = "DNS"

#   tags = {
#     Name = "${var.project}-${var.environment}-wildcard-sslcert"
#   }

#   # この設定は推奨らしい
#   # 削除する前に、作成するという設定
#   lifecycle {
#     create_before_destroy = true
#   }

#   # Route53ホストゾーン作成後に作成
#   depends_on = [
#     aws_route53_zone.route53_zone
#   ]
# }


# ## これはDNS検証用のレコード
# ## このドメインの所有者である証拠を示すためのレコード
# ## ここのレコードをAWSエンジン(ACM)が確認する.
# resource "aws_route53_record" "route53_acm_dns_resolve" {
#   for_each = {
#     # aws_acm_certificate.tokyo_cert.domain_validation_options
#     # ↑ ACMが「このレコードを登録して」と指示してくる
#     for dvo in aws_acm_certificate.tokyo_cert.domain_validation_options : dvo.domain_name => {
#       # リソースレコードの名称
#       name = dvo.resource_record_name
#       # Aタイプとか、NCタイプとか
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }

#   allow_overwrite = true
#   zone_id         = aws_route53_zone.route53_zone.zone_id
#   name            = each.value.name
#   type            = each.value.type
#   ttl             = 600
#   records         = [each.value.record]
# }

# # DNS レコードを作ったあと、ACM 側がその検証を完了するまで待つ
# # といった処理を可能にする
# # validation_record_fqdns に先ほど作った Route53 レコードの FQDN（完全なドメイン名）を渡している
# resource "aws_acm_certificate_validation" "cert_valid" {
#   certificate_arn         = aws_acm_certificate.tokyo_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.route53_acm_dns_resolve : record.fqdn]
# }

# # もしかしたら、今のACM壊れているかも
# # 再発行コマンド
# # aws acm delete-certificate --certificate-arn arn:aws:acm:ap-northeast-1:422296719457:certificate/e8db331b-10d5-42f3-9d9c-1f54cde549f3
# # terraform apply -replace="aws_acm_certificate.tokyo_cert"
