# S3もそこまでお金がかからないので, アプリのバイナリ配布用にS3バケットを作成しておく

## S3関連の設定
## アプリのバイナリをここから配布する. 複数インスタンスを予定しているため
resource "aws_s3_bucket" "app_scripts" {
  bucket = "${var.project}-${var.environment}-${var.ver}-app-scritps"

  # 削除しやすくする設定
  force_destroy = true

  # 今回バージョニングは有効化しない

  tags = {
    Name        = "${var.project}-${var.environment}-${var.ver}-app-scripts"
    Project     = var.project
    Environment = var.environment
  }
}

# S3バケットポリシー（オプション：制限付きアクセスにしたい場合）
resource "aws_s3_bucket_policy" "restrict_public_access" {
  # どのバケットに付与するか
  bucket = aws_s3_bucket.app_scripts.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyPublicRead",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.app_scripts.arn}/*",
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# パブリックアクセスのブロック
resource "aws_s3_bucket_public_access_block" "app_scripts_cidr_block" {
  bucket = aws_s3_bucket.app_scripts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3バケットが作成される前に、パブリックアクセスブロックリソースが作成される可能性があるため
  depends_on = [aws_s3_bucket.app_scripts]
}


## ALBログ出力用のS3バケット
# resource "aws_s3_bucket" "alb_log_bucket" {
#   bucket        = "${var.project}-${var.environment}-${var.ver}-alb-log-bucket"
#   force_destroy = true

#   tags = {
#     Name    = "${var.project}-${var.environment}-${var.ver}-alb-log-bucket"
#     Project = var.project
#     Env     = var.environment
#     Ver     = var.ver
#   }
# }

# data "aws_elb_service_account" "main" {}

# data "aws_iam_policy_document" "allow_elb_logging" {
#   statement {
#     effect = "Allow"

#     # ALBサービスのログをS3に保存する際に、ここで取得したアカウントを取得するらしい
#     principals {
#       type        = "AWS"
#       identifiers = [data.aws_elb_service_account.main.arn]
#     }

#     actions   = ["s3:PutObject"]
#     resources = ["${aws_s3_bucket.alb_log_bucket.arn}/*"]
#   }
# }


# ## バケットポリシー(権限ポリシー)
# resource "aws_s3_bucket_policy" "alb_log_bucket_policy" {
#   bucket = aws_s3_bucket.alb_log_bucket.id
#   policy = data.aws_iam_policy_document.allow_elb_logging.json
# }