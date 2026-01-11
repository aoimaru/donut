# ECRリポジトリ

# このリソース. もしかしたらterraform管理外がいいかも
resource "aws_ecr_repository" "app" {
  name = "${var.project}-${var.environment}-app"

  image_tag_mutability = "MUTABLE" # 最初はこれでOK

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = var.project
    Env     = var.environment
  }
}
