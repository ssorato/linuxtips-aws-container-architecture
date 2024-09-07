resource "aws_security_group" "ecs_alb" {
  name   = format("ecs-alb-%s", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    {
      Name = format("ecs-alb-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "ingress_http" {
  cidr_blocks       = var.alb_ingress_cidr_enabled
  from_port         = 80
  to_port           = 80
  description       = "Enable ingress HTTP"
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_alb.id
  type              = "ingress"
}

resource "aws_security_group_rule" "ingress_https" {
  cidr_blocks       = var.alb_ingress_cidr_enabled
  from_port         = 443
  to_port           = 443
  description       = "Enable ingress HTTPS"
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_alb.id
  type              = "ingress"
}

resource "aws_lb" "ecs_alb" {
  name               = format("ecs-alb-%s", var.project_name)
  internal           = false
  load_balancer_type = "application"

  subnets = data.aws_ssm_parameter.public_subnet[*].value

  security_groups = [
    aws_security_group.ecs_alb.id
  ]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false

  tags = merge(
    {
      Name = format("ecs-alb-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "ecs_alb" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "LinuxTips"
      status_code  = "200"
    }
  }

  tags = merge(
    {
      Name = format("ecs-alb-listner-%s", var.project_name)
    },
    var.common_tags
  )
}