resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true  # ここら辺の値はすべて固定しておく
  enable_dns_hostnames             = true  # ここら辺の値はすべて固定しておく
  assign_generated_ipv6_cidr_block = false # ここら辺の値はすべて固定しておく

  tags = {
    Name    = "vpc-${var.project}-${var.environment}-${var.ver}"
    Project = var.project
    Env     = var.environment
    Ver     = var.ver
  }
}
