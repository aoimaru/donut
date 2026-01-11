# DBインスタンス用のパスワード生成
resource "random_password" "initial_password" {
  length  = 16
  special = false
}
