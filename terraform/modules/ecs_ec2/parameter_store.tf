resource "aws_ssm_parameter" "alb_arn" {
  name  = format("/%s/ecs/lb/arn", var.project_name)
  value = aws_lb.ecs_alb.arn
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/lb/arn", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "alb_listener_arn" {
  name  = format("/%s/ecs/lb/listerner_arn", var.project_name)
  value = aws_lb_listener.ecs_alb.arn
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/lb/listerner_arn", var.project_name)
    },
    var.common_tags
  )
}
