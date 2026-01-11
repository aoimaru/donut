# IAM周りのリソースを定義
## ここではterraform-aws-moduleを利用しない そこまで面倒な作業ではないため

# 定義したリソース
# - SSM接続用のIAMロールとインスタンスプロファイル
# - アプリケーションサーバ用のIAMロールとインスタンスプロファイル

# 依存リソース
# - 特になし　ここで定義したIAMロールとインスタンスプロファイルを, EC2インスタンスが利用する

# --- SSM用のIAMロール -----------------------------------------------------------------------
resource "aws_iam_role" "ssm_role" {
  name               = "${var.project}-${var.environment}-${var.ver}-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
# これは信頼ポリシー
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
## SSM用の権限ポリシーをアタッチする
resource "aws_iam_role_policy_attachment" "opmng_ssm_core_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
## Secrets Managerの読み取り権限を付与
resource "aws_iam_role_policy_attachment" "opmng_secretsmanager_readonly_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
# インスタンスプロファイルの作成
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.project}-${var.environment}-${var.ver}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}
# -----------------------------------------------------------------------------------

# --- アプリ用のロール -----------------------------------------------------------------
resource "aws_iam_role" "app_role" {
  name = "${var.project}-${var.environment}-${var.ver}-app-role"
  ## これは専用で用意した方がいい？
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

}
## インスタンスプロファイルの作成
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.project}-${var.environment}-${var.ver}-app-instance-profile"
  role = aws_iam_role.app_role.name

  lifecycle {
    # apply時に新しくロールを新規作成して、成功したら古いロールを削除する
    create_before_destroy = true
  }
}
## SSMとSecrets Managerの読み取り権限を付与
resource "aws_iam_role_policy_attachment" "secretsmanager_readonly_policy" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
## SSM用のポリシーもアタッチ
resource "aws_iam_role_policy_attachment" "app_ssm_core_policy" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## この2つはセット
data "aws_iam_policy_document" "s3_readonly_policy_doc" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.app_bucket.arn}/*"]
    effect    = "Allow"
  }
}
resource "aws_iam_role_policy_attachment" "s3_readonly_policy" {
  # ここ設定がダブっているからいらないかも
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
# -----------------------------------------------------------------------------------


# メモ
# - <インスタンスプロファイル> -- <IAMロール> -- <権限ポリシー> のイメージ
# -　　↑ ここではEC2インスタンスに紐付ける
# - インスタンスプロファイルはIAMロールを紐付けるためのコンテナ？らしい
