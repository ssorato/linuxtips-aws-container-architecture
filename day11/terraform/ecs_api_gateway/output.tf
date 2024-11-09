output "health_api_invoke_url" {
  value = "${aws_api_gateway_deployment.health_api.invoke_url}${var.environment}"
}

output "api_gateway_domain_name" {
  value = length(aws_api_gateway_domain_name.main) > 0 ? aws_api_gateway_domain_name.main[0].regional_domain_name : "no custom domain name"
}