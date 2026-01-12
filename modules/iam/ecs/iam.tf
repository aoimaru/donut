
# ECSで利用するロール回り

# こいつはアプリ起動に必要なロール
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-${var.environment}-${var.ver}-ecs-task-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# これはアプリ実行中に, アプリがAWSAPIを叩くための権限
resource "aws_iam_role" "ecs_task" {
  name = "${var.project}-${var.environment}-${var.ver}-ecs-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_exec" {
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ]
      Resource = "*"
    }]
  })
}
# CreateControlChannel
# Control Channel の役割
#  セッション開始
#  セッション終了
#  exec コマンドの指示
#  エラー通知

# OpenControlChannel
# 「作った制御チャネルを実際に接続する」権限

# CreateDataChannel
# 「データ転送用チャネルを作る」権限

# secrets manager 読み書き用のIAMポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ecs_secrets_read" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# こっちも必要に応じて追加する
# resource "aws_iam_role_policy_attachment" "ecs_s3_readonly" {
#   role       = aws_iam_role.ecs_task.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }
