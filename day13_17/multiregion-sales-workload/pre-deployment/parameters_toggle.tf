resource "aws_ssm_parameter" "primary" {
  name  = format("/%s/site/state", var.project_name)
  type  = "String"
  value = lookup(var.active_states, var.region_primary)

  tags = merge(
    {
      Name = format("/%s/site/state", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "secondary" {
  provider = aws.secondary
  name     = format("/%s/site/state", var.project_name)
  type     = "String"
  value    = lookup(var.active_states, var.region_secondary)

  tags = merge(
    {
      Name = format("/%s/site/state", var.project_name)
    },
    var.common_tags
  )
}
