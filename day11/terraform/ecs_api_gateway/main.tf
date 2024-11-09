resource "aws_api_gateway_rest_api" "health_api" {
  name = format("%s-health-api-%s", var.project_name, var.environment)

  body = file("${path.module}/environment/${var.environment}/openapi.json")

  description = "API used to calculate macros"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    {
      Name = format("%s-health-api-%s", var.project_name, var.environment)
    },
    var.common_tags
  )
}

resource "aws_api_gateway_deployment" "health_api" {
  rest_api_id = aws_api_gateway_rest_api.health_api.id

  triggers = {
    redeploy = sha256(jsonencode(aws_api_gateway_rest_api.health_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "health_api" {
  deployment_id = aws_api_gateway_deployment.health_api.id
  rest_api_id   = aws_api_gateway_rest_api.health_api.id
  stage_name    = var.environment

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.health_api.arn
    format = jsonencode({
      requestId         = "$context.requestId",
      ip                = "$context.identity.sourceIp",
      caller            = "$context.identity.caller",
      user              = "$context.identity.user",
      requestTime       = "$context.requestTime",
      httpMethod        = "$context.httpMethod",
      resourcePath      = "$context.resourcePath",
      status            = "$context.status",
      protocol          = "$context.protocol",
      responseLength    = "$context.responseLength",
      responseTime      = "$context.responseLatency",
      responseBody      = "$context.responseBody",
      integrationStatus = "$context.integrationStatus",
      errorMessage      = "$context.error.message",
      errorType         = "$context.error.responseType"
    })
  }

  variables = {
    vpcLinkId = data.aws_ssm_parameter.vpc_link.value
  }

  tags = var.common_tags
}

resource "aws_api_gateway_method_settings" "health_api" {
  rest_api_id = aws_api_gateway_rest_api.health_api.id
  stage_name  = aws_api_gateway_stage.health_api.stage_name

  method_path = "*/*"

  settings {
    throttling_rate_limit  = 10
    throttling_burst_limit = 10

    logging_level = "INFO"

    metrics_enabled    = true
    data_trace_enabled = true
  }
}
