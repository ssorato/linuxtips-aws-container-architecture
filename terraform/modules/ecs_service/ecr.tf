resource "aws_ecr_repository" "main" {
  name         = format("%s/%s", var.ecs_name, var.ecs_service_name)
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    {
      Name = format("%s-%s", var.ecs_name, var.ecs_service_name)
    },
    var.common_tags
  )
}