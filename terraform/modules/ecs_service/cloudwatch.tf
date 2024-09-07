resource "aws_cloudwatch_log_group" "main" {
  name = format("%s/%s/logs", var.ecs_name, var.ecs_service_name)

  tags = merge(
    {
      Name = format("%s/%s/logs", var.ecs_name, var.ecs_service_name)
    },
    var.common_tags
  )
}