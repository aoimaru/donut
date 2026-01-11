# AMIの取得
data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# 既に作成しているリソースを取り込む

## VPCの取り込み
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${var.project}-${var.environment}"]
  }
}

## サブネットの取り込み
data "aws_subnet" "private_subnet_1a" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-subnet-1a"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_subnet" "private_subnet_1c" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-subnet-1c"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_subnet" "public_subnet_1a" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-public-subnet-1a"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_subnet" "public_subnet_1c" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-public-subnet-1c"]
  }
  vpc_id = data.aws_vpc.selected.id
}

# ルートテーブルの読み込み (NATゲートウェイでパブリックサブネットとプライベートサブネットを接続しているため)
data "aws_route_table" "private_rt" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-rt"]
  }
  vpc_id = data.aws_vpc.selected.id
}

## セキュリティグループの取り込み
## web用のセキュリティグループ
## - インバウンド: 80, 443を許可
## - アウトバウンド: アプリサーバへのアクセス(app_sg: ポート8080)のみを許可
data "aws_security_group" "web_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-web-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
## アプリ用のセキュリティグループ
## - インバウンド: web_sgからのアクセス(ポート8080)を許可
##               db_sgからのアクセス(ポート5432)を許可
## - アウトバウンド: RDSへのアクセス(ポート5432)のみを許可
##                SSMエンドポイントへのアクセス(443)も許可
data "aws_security_group" "app_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-app-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
## DB用のセキュリティグループ
## - インバウンド: アプリサーバからのアクセス(ポート5432)を許可
##               踏み台サーバからのアクセス(ポート5432)を許可 (SQLを流すため)
## - アウトバウンド: アプリサーバへのアクセス(ポート8080)のみを許可
data "aws_security_group" "db_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-db-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
## 踏み台サーバ用のセキュリティグループ
## - インバウンド: なし
## - アウトバウンド: SSMエンドポイントへのアクセス(ポート443)を許可
##                 DBサーバへのアクセス(ポート5432)を許可
##                 アプリサーバへのアクセス(ポート8080)を許可
data "aws_security_group" "opmng_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-opmng-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
## SSMエンドポイント用のセキュリティグループ
## インバウンド: EC2インスタンスからの443アクセスを許可
## アウトバウンド: 0.0.0.0 (プライベートサブネット内なので問題なし)
data "aws_security_group" "ssm_endpoint_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-ssm-endpoint-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}

# IAMロールの取り込み
## SSM接続用のIAMロール
data "aws_iam_role" "ssm_instance_role" {
  name = "${var.project}-${var.environment}-${var.ver}-ssm-role"
}
## SSM接続用のインスタンスプロファイルの取り込み
data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.project}-${var.environment}-${var.ver}-ssm-instance-profile"
}

## アプリケーション用のIAMロール
data "aws_iam_role" "app_instance_role" {
  name = "${var.project}-${var.environment}-${var.ver}-app-role"
}
## アプリケーション用のインスタンスプロファイルの取り込み
data "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.project}-${var.environment}-${var.ver}-app-instance-profile"
}

# S3バケットの取り込み
data "aws_s3_bucket" "app_bucket" {
  # ここscriptsがscritpsになっているので後で修正する
  bucket = "${var.project}-${var.environment}-${var.ver}-app-scritps"
}

# secrets-managerの取り込み
data "aws_secretsmanager_secret" "rds_secret" {
  name = "${var.project}-${var.environment}-${var.ver}-secrets"
}

# S3バケットの取り込み
# ALBのログ出力用のバケットを取り込み
data "aws_s3_bucket" "alb_log_bucket" {
  bucket = "${var.project}-${var.environment}-${var.ver}-alb-log-bucket"
}

# Route53の情報を取得
# AレコードはALBを指しているのでcomputeに依存
data "aws_route53_zone" "host_zone" {
  name = var.domain
}

# acm(証明書情報)の追加
data "aws_acm_certificate" "tokyo_cert" {
  domain   = "*.${var.domain}"
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}
