# VPC
output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.vpc.id
}

# サブネット
output "public_subnet_1a_id" {
    value = aws_subnet.public_subnet_1a.id
}
output "public_subnet_1c_id" {
    value = aws_subnet.public_subnet_1c.id
}
output "private_subnet_1a_id" {
    value = aws_subnet.private_subnet_1a.id
}
output "private_subnet_1c_id" {
    value = aws_subnet.private_subnet_1c.id
}

# ルートテーブル
output "public_rt_id" {
    value = aws_route_table.public_rt.id
}
output "private_rt_id" {
    value = aws_route_table.private_rt.id
}

# インターネットゲートウェイ
output "igw_id" {
    value = aws_internet_gateway.igw.id
}

# セキュリティグループ
output "app_sg_id" {
    value = aws_security_group.app_sg.id
}
output "opmng_sg_id" {
    value = aws_security_group.opmng_sg.id
}
output "ssm_endpoint_sg_id" {
    value = aws_security_group.ssm_endpoint_sg.id
}