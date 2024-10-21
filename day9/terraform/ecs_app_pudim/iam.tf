#
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
# This role allows your application code (on the container) to use other AWS services
#

resource "aws_iam_role" "ecs_task_execution_role" {
  name = format("%s-role-%s", var.ecs_service.name, var.project_name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  tags = merge(
    {
      Name = format("%s-role-%s", var.ecs_service.name, var.project_name)
    },
    var.common_tags
  )
}

resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = format("%s-policy-%s", var.ecs_service.name, var.project_name)
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "s3:GetObject",
          "sqs:*",
        ],
        Resource = "*",
        Effect   = "Allow"
      },
    ]
  })
}
