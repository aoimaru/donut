resource "aws_ecs_service" "app" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [
        data.aws_subnet.public_subnet_1a,
        data.aws_subnet.public_subnet_1c
    ]
    security_groups = [data.aws_security_group.ecs_sg.id] # TODO セキュリティグループの作成
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app" #TODO 確定させる
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [desired_count] # AutoScaling使うなら必須
  }

# こいつは事前に作成させるので, 依存関係を明示する必要はなし
#   depends_on = [
#     aws_lb_listener.https
#   ]
}
