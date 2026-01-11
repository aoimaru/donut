# パラメータグループ
# DBの設定ファイル
# コネクション数とかを管理する
resource "aws_db_parameter_group" "postgresql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-postgresql-standalone-parametergroup"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "1" # SSLを強制
  }
}

resource "aws_db_option_group" "postgresql_standalone_optiongroup" {
  # name                 = "${var.project}-${var.environment}-${var.ver}-postgresql-standalone-optiongroup"
  name                 = "${var.project}-${var.environment}-postgresql-standalone-optiongroup"
  engine_name          = "postgres"
  major_engine_version = "15"
}

# RDSは必ずサブネットグループに所属させる必要がある
resource "aws_db_subnet_group" "postgresql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-postgresql-standalone-subnetgroup"
  subnet_ids = [
    data.aws_subnet.private_subnet_1a.id,
    data.aws_subnet.private_subnet_1c.id
  ] # プライベートサブネットに配置

  tags = {
    Name    = "${var.project}-${var.environment}-postgresql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

# DBインスタンスの設定
resource "aws_db_instance" "postgresql_standalone" {
  engine         = "postgres"
  engine_version = "15.10"

  identifier = "${var.project}-${var.environment}-postgresql-standalone"
  db_name    = "main"

  username = "developer"
  password = random_password.initial_password.result

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.postgresql_standalone_subnetgroup.name
  vpc_security_group_ids = [data.aws_security_group.db_sg.id]
  # 踏み台サーバからのみアクセス可能にする設定
  publicly_accessible = false
  port                = 5432

  # パラメータグループとオプショングループ(追加設定)を指定
  parameter_group_name = aws_db_parameter_group.postgresql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.postgresql_standalone_optiongroup.name

  # sandbox環境なのでスナップショットは不要
  deletion_protection = false
  skip_final_snapshot = true

  # 変更を即時適用するか
  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-postgresql-standalone"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}
