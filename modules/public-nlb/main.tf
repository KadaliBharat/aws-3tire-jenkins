# main.tf
resource "aws_lb" "public" {
  name               = "${var.environment}-public-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  security_groups    = [var.nlb_sg_id]

  tags = { Name = "${var.environment}-public-nlb" }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.environment}-web-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
