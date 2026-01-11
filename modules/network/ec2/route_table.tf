# - NATゲートウェイはコストがかかるため, 別枠で作成する

# --- パブリックサブネットに紐付けているルートテーブル ------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
    Ver     = var.ver
  }
}
# ここでルートテーブルとサブネットを紐づけている
resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}
resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}
# NATゲートウェイはお金がかかるので, 別枠で作成 あとで紐づける
# ----------------------------------------------------------------------

# --- プライベートサブネット紐づけているルートテーブル ------------------------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-private-rt"
    Project = var.project
    Env     = var.environment
    Type    = "private"
    Ver     = var.ver
  }
}
resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}
resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}
# ----------------------------------------------------------------------
