resource "aws_alb" "stopnshop-prod-alb" {
  name                             = "stopnshop-prod-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.stopnshop-alb-sg.id]
  subnets                          = [aws_subnet.stopnshop-prod-alb-1a.id, aws_subnet.stopnshop-prod-alb-1b.id]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
  ip_address_type                  = "ipv4"

  tags = {
    Name        = "stopnshop-prod-alb"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}

resource "aws_alb_listener" "name" {
  load_balancer_arn = aws_alb.stopnshop-prod-alb.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stopnshop-prod-alb-tgrp.arn
  }
}