resource "aws_ssm_parameter" "teste" {
  name  = "/Parameter/chip-teste-parameter"
  type  = "String"
  value = "VIM DO PARAMETER STORE"

  tags = merge(
    {
      Name = "/Parameter/chip-teste-parameter"
    },
    var.common_tags
  )
}
