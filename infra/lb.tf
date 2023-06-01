resource "aws_lb" "backend" {
  name = "lb-backend-dev"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb_dev.id, aws_security_group.dev_backend_task.id, aws_security_group.backend.id]
}

resource "aws_lb_target_group" "backend" {
  name = "target-group-dev"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.backend.id
    type             = "forward"
  }
}
