# 踏み台サーバ(SSM接続)用の設定
resource "aws_instance" "opmng_ssm_ec2" {
  ami                    = data.aws_ami.bastion.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.private_subnet_1a.id
  vpc_security_group_ids = [data.aws_security_group.opmng_sg.id]

  iam_instance_profile = data.aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-opmng-ssh-ec2"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

# 認証サーバ用の設定
# こっちは, 非Dockerアプリケーションを配置
resource "aws_instance" "app_server_1a" {
  ami                    = data.aws_ami.app.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.private_subnet_1a.id
  vpc_security_group_ids = [data.aws_security_group.app_sg.id]

  # 外部公開のサーバなのでパブリックIPを付与
  # associate_public_ip_address = true

  # IAMロールをインスタンスプロファイルとして紐付け
  iam_instance_profile = data.aws_iam_instance_profile.app_instance_profile.name

  # スクリプトを流し込む
  # user_data = file("./scripts/start-service.sh")

  tags = {
    Name    = "${var.project}-${var.environment}-app-server-1a"
    Project = var.project
    Env     = var.environment
  }

  # これ多分要らない
  # depends_on = [
  #   aws_nat_gateway.nat
  # ]
}

# 認証サーバ用の設定
# こっちはDockerアプリケーションを配置
resource "aws_instance" "app_server_1c" {
  ami                    = data.aws_ami.app.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.private_subnet_1c.id
  vpc_security_group_ids = [data.aws_security_group.app_sg.id]

  iam_instance_profile = data.aws_iam_instance_profile.app_instance_profile.name

  tags = {
    Name    = "${var.project}-${var.environment}-app-server-1c"
    Project = var.project
    Env     = var.environment
  }
}



# # ALBのターゲット登録 (EC2インスタンスを登録) こいつcomputeで定義するといいのでは?
# resource "aws_lb_target_group_attachment" "app_server_1a_attachment" {
#   target_group_arn = aws_lb_target_group.app_alb_target_group.arn
#   target_id        = aws_instance.app_server_1a.id
#   port             = 8080
# }
# ## TODO: Dockerアプリケーション用のサーバも登録
