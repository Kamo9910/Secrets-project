resource "aws_lb_target_group" "tp" {
  name = "${var.app-name}-target-group"
  port = var.container_port
  protocol = "HTTP"
  vpc_id = aws_vpc.this.id
  target_type = "ip"
  health_check {
    path = "/"
    interval = 30
    timeout = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}

