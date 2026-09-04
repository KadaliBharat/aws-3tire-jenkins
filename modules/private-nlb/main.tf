# main.tf
resource "aws_lb" "private" {
  name               = "${var.environment}-private-nlb"
  internal           = true # Critical: Internal NLB
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids
  security_groups    = [var.private_nlb_sg_id]

  tags = { Name = "${var.environment}-private-nlb" }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.environment}-app-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.private.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
