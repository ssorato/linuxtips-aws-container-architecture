resource "aws_api_gateway_api_key" "sample" {
  name    = "Sample API KEY"
  enabled = true

  tags = merge(
    {
      Name = "Sample API KEY"
    },
    var.common_tags
  )
}

resource "aws_api_gateway_usage_plan" "sample" {
  name = "Health-API: Sample Usage Plan"

  throttle_settings {
    burst_limit = 10
    rate_limit  = 1
  }

  quota_settings {
    limit  = 100000
    period = "MONTH"
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.health_api.id
    stage  = aws_api_gateway_stage.health_api.stage_name
  }

  tags = merge(
    {
      Name = "Health-API: Sample Usage Plan"
    },
    var.common_tags
  )
}

resource "aws_api_gateway_usage_plan_key" "sample" {
  key_id        = aws_api_gateway_api_key.sample.id
  usage_plan_id = aws_api_gateway_usage_plan.sample.id
  key_type      = "API_KEY"
}
