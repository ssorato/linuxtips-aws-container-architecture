resource "aws_ssm_parameter" "ecs_task_parameter_sample" {
  name  = format("%s-sample-parameter", var.ecs_service.name)
  type  = "String"
  value = "Sample from parameters store v1"
}
