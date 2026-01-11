# シークレットマネージャ関連
resource "aws_secretsmanager_secret" "novel_secret" {
  # ここの名前, 7日間制限があったはず. コマンドを記録しておく: 
  name        = "${var.project}-${var.environment}-${var.ver}-secrets"
  description = "Rotated NOVEL credentials"
}

## 実際のシークレットの値は削除がすぐできる状態にするために別プロジェクトで管理
## computeと同期している印象が強いのでそこに配置