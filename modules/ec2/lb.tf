# ~~runtime-networkは事前に作成しておく~~
# runtime-networkが後
resource "aws_lb" "app_alb" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.web_sg.id]
  subnets            = [data.aws_subnet.public_subnet_1a.id, data.aws_subnet.public_subnet_1c.id]

  access_logs {
    bucket = data.aws_s3_bucket.alb_log_bucket.id
  }

  tags = {
    Name    = "${var.project}-${var.environment}-app-alb"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

# ALBのリスナー設定 (ポート80で待ち受け)
## 一旦は80だけ
resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}

# リスナーにルールを追加
# EC2 用
resource "aws_lb_listener_rule" "api_to_ec2" {
  listener_arn = aws_lb_listener.app_alb_listener.arn
  priority     = 10

  condition {
    host_header {
      values = ["ec2.${var.domain}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}

# ECS 用
resource "aws_lb_listener_rule" "app_to_ecs" {
  listener_arn = aws_lb_listener.app_alb_listener.arn
  priority     = 20

  condition {
    host_header {
      values = ["ecs.${var.domain}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn # TODO ここ作成
  }
}

# TODO: ドメインのプロジェクトで追加
# TODO: ACM情報の取り込み

resource "aws_lb_listener" "app_alb_listener_https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # 証明書の指定. 個のサーバ証明書をリクエスト時にクライアントに送付する
  certificate_arn = data.aws_acm_certificate.tokyo_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}

# ALBのターゲットグループ設定
## どのサーバにデータを流すかを定義する
## VPCは既に取り込み済み
resource "aws_lb_target_group" "app_alb_target_group" {
  name     = "${var.project}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path = "/"
    # path                = "/user_codes"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name    = "${var.project}-tg"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

resource "aws_lb_target_group" "ecs_alb_target_group" {
  name     = "${var.project}-ecs-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path = "/"
    # path                = "/user_codes"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name    = "${var.project}-ecs-tg"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

# ターゲットグループへのアタッチメントを実施
# data "aws_lb_target_group" "app_alb_target_group" {
#     name = "${var.project}-tg"
# }

resource "aws_lb_target_group_attachment" "app_server_1a_attachment" {
  target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  target_id        = aws_instance.app_server_1a.id
  port             = 8080
}