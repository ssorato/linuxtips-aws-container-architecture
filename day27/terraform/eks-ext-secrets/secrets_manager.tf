resource "aws_secretsmanager_secret" "teste" {
  name = "chip-teste"
  recovery_window_in_days = 0 # force deletion without recovery 

  tags = merge(
    {
      Name = "chip-teste"
    },
    var.common_tags
  )
}

resource "aws_secretsmanager_secret_version" "teste" {
  secret_id     = aws_secretsmanager_secret.teste.id
  secret_string = "BAR"
}

resource "aws_secretsmanager_secret" "teste_json" {
  name = "chip-teste-json"
  recovery_window_in_days = 0 # force deletion without recovery 

  tags = merge(
    {
      Name = "chip-teste-json"
    },
    var.common_tags
  )
}

resource "aws_secretsmanager_secret_version" "teste_json" {
  secret_id = aws_secretsmanager_secret.teste_json.id
  secret_string = jsonencode({
    foo      = "BAR",
    username = "admin",
    password = "abc123"
  })
}
