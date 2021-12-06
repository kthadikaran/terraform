resource "aws_lb_target_group" "stopnshop-prod-alb-tgrp" {
  name     = "stopnshop-prod-alb-tgrp"
  vpc_id   = aws_vpc.stopnshop-prod-vpc.id
  port     = 80
  protocol = "HTTP"

  health_check {
    interval            = 10
    path                = "/index.html"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name        = "stopnshop-prod-alb-tgrp"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

resource "aws_lb_target_group_attachment" "stopnshop-alb-tgrp-instance" {
  count            = length(aws_instance.stopnshop-webserver)
  target_group_arn = aws_lb_target_group.stopnshop-prod-alb-tgrp.arn
  target_id        = aws_instance.stopnshop-webserver[count.index].id
  port             = 80
}

