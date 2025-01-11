resource "aws_ssm_parameter" "lb_internal_arn" {
  type  = "String"
  name  = format("/%s/lb/internal/arn", var.project_name)
  value = module.cluster.lb_internal_arn

  tags = merge(
    {
      Name = format("/%s/lb/internal/arn", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "lb_internal_listener_arn" {
  type  = "String"
  name  = format("/%s/lb/internal/http/listener", var.project_name)
  value = module.cluster.lb_internal_listener

  tags = merge(
    {
      Name = format("/%s/lb/internal/http/listener", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "lb_internal_listener_https_arn" {
  type  = "String"
  name  = format("/%s/lb/internal/https/listener", var.project_name)
  value = module.cluster.lb_internal_listener_https

  tags = merge(
    {
      Name = format("/%s/lb/internal/https/listener", var.project_name)
    },
    var.common_tags
  )
}


resource "aws_ssm_parameter" "service_discovery_cloudmap_name" {
  type  = "String"
  name  = format("/%s/service-discovery/cloudmap/name", var.project_name)
  value = module.cluster.service_discovery_cloudmap_name

  tags = merge(
    {
      Name = format("/%s/service-discovery/cloudmap/name", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "service_discovery_cloudmap_id" {
  type  = "String"
  name  = format("/%s/service-discovery/cloudmap/id", var.project_name)
  value = module.cluster.service_discovery_cloudmap

  tags = merge(
    {
      Name = format("/%s/service-discovery/cloudmap/id", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "service_discovery_service_connect_name" {
  type  = "String"
  name  = format("/%s/service-discovery/service-connect/name", var.project_name)
  value = module.cluster.service_discovery_service_connect_name

  tags = merge(
    {
      Name = format("/%s/service-discovery/service-connect/name", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "service_discovery_service_connect_id" {
  type  = "String"
  name  = format("/%s/service-discovery/service-connect/id", var.project_name)
  value = module.cluster.service_discovery_service_connect

  tags = merge(
    {
      Name = format("/%s/service-discovery/service-connect/id", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "vpc_link" {
  type  = "String"
  name  = format("/%s/vpc-link/id", var.project_name)
  value = module.cluster.vpc_link

  tags = merge(
    {
      Name = format("/%s/vpc-link/id", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "vpc_link_arn" {
  type  = "String"
  name  = format("/%s/vpc-link/arn", var.project_name)
  value = module.cluster.vpc_link_nlb_arn

  tags = merge(
    {
      Name = format("/%s/vpc-link/arn", var.project_name)
    },
    var.common_tags
  )
}
