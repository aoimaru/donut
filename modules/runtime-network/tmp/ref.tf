# 外部からのリソースの参照

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
data "aws_route_table" "private_rt" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-${var.ver}-private-rt"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_security_group" "web_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-web-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}
data "aws_security_group" "ssm_endpoint_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project}-${var.environment}-${var.ver}-ssm_endpoint_sg"]
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
data "aws_s3_bucket" "alb_log_bucket" {
  bucket = "${var.project}-${var.environment}-${var.ver}-alb-log-bucket"
}

# SSL証明書の参照
data "aws_acm_certificate" "tokyo_cert" {
  domain   = "*.${var.domain}"
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}

# ロードバランサ読み込み
data "aws_lb" "app_alb" {
  name = "${var.project}-${var.environment}-alb"
}