resource "aws_api_gateway_domain_name" "main" {
  count                    = var.dns_name == null || var.aws_acm_certificate_arn == null ? 0 : 1
  regional_certificate_arn = var.aws_acm_certificate_arn

  domain_name = var.dns_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "v1" {
  count       = length(aws_api_gateway_domain_name.main) > 0 ? 1 : 0
  api_id      = aws_api_gateway_rest_api.health_api.id
  stage_name  = aws_api_gateway_stage.health_api.stage_name
  domain_name = aws_api_gateway_domain_name.main[0].domain_name
  base_path   = var.base_mapping
}
