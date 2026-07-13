# Load Balancer
resource "aws_lb" "benjaminfiche" {
  name               = "${var.ec2_instance_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

# Target group
resource "aws_alb_target_group" "default-target-group" {
  name     = "${var.ec2_instance_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.benjaminfiche-vpc.id

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 60
    matcher             = "200"
  }

  tags = {
    name = "BenjaminFiche-alb-target-group"
  }
}

resource "aws_alb_target_group" "default-target-group-2" {
  name     = "${var.ec2_instance_name}-tg-bastion"
  port     = 22
  protocol = "HTTP"
  vpc_id   = aws_vpc.benjaminfiche-vpc.id

  tags = {
    name = "BenjaminFiche-alb-target-group-2"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.ec2-cluster.id
  lb_target_group_arn    = aws_alb_target_group.default-target-group.arn
}

# resource "aws_autoscaling_attachment" "asg_attachment_bar-2" {
#   autoscaling_group_name = aws_autoscaling_group.bastion-cluster.id
#   lb_target_group_arn    = aws_alb_target_group.default-target-group-2.arn
# }

resource "aws_alb_listener" "ec2-alb-http-listener" {
  load_balancer_arn = aws_lb.benjaminfiche.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.validation.certificate_arn
  depends_on        = [aws_alb_target_group.default-target-group]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default-target-group.arn
  }

  tags = {
    name = "BenjaminFiche-alb-http-listener"
  }
}