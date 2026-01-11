# 外部から変更不可の定数
locals {
  # 組み込み関数の cidrsubnet を利用 
  # https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
  subnet_cidr_blocks = [for i in range(0, 4) : cidrsubnet(var.cidr_block, 4, i)]
}
