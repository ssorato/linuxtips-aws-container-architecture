resource "aws_secretsmanager_secret" "ecs_task_secret" {
  name = format("%s-ecs-task-secret", var.ecs_service.name)

  tags = merge(
    {
      Name = format("%s-ecs-task-secret", var.ecs_service.name)
    },
    var.common_tags
  )
}

resource "aws_secretsmanager_secret_version" "ecs_task_secret_sample" {
  secret_id     = aws_secretsmanager_secret.ecs_task_secret.id
  secret_string = "Sample secret from secret manager v1"
}
