# 依存リソース
# - VPC
# - IGWはVPCに紐づけられる

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-igw"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

# パブリック用のルートテーブルにデフォルトルートを追加
resource "aws_route" "public_rt_igw_r" {
  # パブリック用のルートテーブルに来た通信で
  route_table_id = aws_route_table.public_rt.id
  # 外向きの全ての通信をインターネットゲートウェイに送る
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
