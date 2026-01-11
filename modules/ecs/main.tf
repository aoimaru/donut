# Terrraformの公式ドキュメントより

# Terraformの設定
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
