resource "aws_api_gateway_domain_name" "main" {
  regional_certificate_arn = aws_acm_certificate.main.arn

  domain_name = var.dns_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    {
      Name = var.dns_name
    },
    var.common_tags
  )

  # creating API Gateway Domain Name: BadRequestException: Certificate in account not yet issued
  depends_on = [
    aws_acm_certificate_validation.main
  ]
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  domain_name = aws_api_gateway_domain_name.main.domain_name
}

