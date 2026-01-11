## VPCエンドポイントに関する設定

## SSM用のVPCエンドポイントを作成. こいつらはプライベートDNSで, ENIに解決される
locals {
  ssm_services = [
    "com.amazonaws.ap-northeast-1.ssm",
    "com.amazonaws.ap-northeast-1.ec2messages",
    "com.amazonaws.ap-northeast-1.ssmmessages"
  ]
}

# プライベートサブネット内のノードが増えるイメージ
# 既存 アプリケーションサーバ用のインスタンスのみ(i-xxxのeth0)
# 新規 VPCエンドポイント用のENI (vpce-xxxのeth1, eth2, ...)


# エンドポイントはプライベートサブネット内に配置する
resource "aws_vpc_endpoint" "vpc_endpoint_for_ssm" {
  for_each     = toset(local.ssm_services)
  vpc_id       = data.aws_vpc.selected.id
  # サービスごとに作成
  service_name = each.key
  # インタフェース型なので、プライベートサブネット内にENI(仮想的なNIC)を作成する
  vpc_endpoint_type = "Interface"
  # SSM専用のVPCエンドポイント用セキュリティグループを指定
  security_group_ids = [data.aws_security_group.ssm_endpoint_sg.id]
  # プライベートサブネット内に配置するので, プライベートサブネットのIDを指定
  subnet_ids = [
    data.aws_subnet.private_subnet_1a.id,
    data.aws_subnet.private_subnet_1c.id
  ]
  private_dns_enabled = true

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-ssm-vpc-endpoint"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_for_s3" {
  vpc_id = data.aws_vpc.selected.id
  # こいつもプライベートDNSで名前解決している
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    data.aws_route_table.private_rt.id
  ]
  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-s3-vpc-endpoint"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}