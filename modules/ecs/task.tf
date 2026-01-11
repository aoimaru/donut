resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = templatefile(
    "${path.module}/container_definition_template.json",
    {
      ecr_repository_url = data.aws_ecr_repository.app.repository_url
      image_tag          = "latest"

      container_port     = 8080

      log_group_name     = aws_cloudwatch_log_group.ecs.name
      region             = "ap-northeast-1"
      log_stream_prefix  = "ecs"
    }
  )
}
