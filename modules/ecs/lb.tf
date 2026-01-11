# runtime-networkは事前に作成しておく

# ターゲットグループへのアタッチメントを実施
data "aws_lb_target_group" "ecs_alb_target_group" {
    name = "${var.project}-ecs-tg"
}
resource "aws_lb_target_group_attachment" "app_server_1a_attachment" {
  target_group_arn = data.aws_lb_target_group.ecs_alb_target_group.arn
  target_id        = aws_instance.app_server_1a.id # TODO: 修正
  port             = 8080
}