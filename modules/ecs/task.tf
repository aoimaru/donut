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
      ecr_repository_url_for_app = data.aws_ecr_repository.app.repository_url
      image_tag_for_app          = "latest"
      container_port_for_app     = 8080
      log_group_name_for_app     = aws_cloudwatch_log_group.ecs.name
      region_for_app             = "ap-northeast-1"
      log_stream_prefix_for_app  = "app"

      ecr_repository_url_for_opmng = data.aws_ecr_repository.app.repository_url
      image_tag_for_opmng          = "latest"
      
      # こっちいらないかも...
      # container_port_for_opmng     = 8080
      # log_group_name_for_opmng     = aws_cloudwatch_log_group.ecs.name
      # region_for_opmng             = "ap-northeast-1"
      # log_stream_prefix_for_opmng  = "opmng"
    }
  )
}
