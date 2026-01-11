## ALBログ出力用のS3バケット
resource "aws_s3_bucket" "alb_log_bucket" {
  bucket        = "${var.project}-${var.environment}-${var.ver}-alb-log-bucket"
  force_destroy = true

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-alb-log-bucket"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "allow_elb_logging" {
  statement {
    effect = "Allow"

    # ALBサービスのログをS3に保存する際に、ここで取得したアカウントを取得するらしい
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.alb_log_bucket.arn}/*"]
  }
}


## バケットポリシー(権限ポリシー)
resource "aws_s3_bucket_policy" "alb_log_bucket_policy" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  policy = data.aws_iam_policy_document.allow_elb_logging.json
}