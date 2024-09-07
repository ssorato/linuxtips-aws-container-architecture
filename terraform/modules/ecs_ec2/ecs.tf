resource "aws_ecs_cluster" "main" {
  name = format("ecs-%s", var.project_name)

  setting {
    name  = "containerInsights" # ECS Container Insights metrics
    value = "enabled"
  }

  tags = merge(
    {
      Name = format("ecs-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name
  capacity_providers = [
    aws_ecs_capacity_provider.on_demand.name,
    aws_ecs_capacity_provider.spot.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.on_demand.name
    weight            = 100
    base              = 0
  }
}

resource "aws_ecs_capacity_provider" "on_demand" {
  name = format("on-demand-ecs-%s", var.project_name) # don't use ecs prefix ( reserved )

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.on_demand.arn
    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 90
    }
  }

  tags = merge(
    {
      Name = format("on-demand-ecs-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ecs_capacity_provider" "spot" {
  name = format("spot-ecs-%s", var.project_name)

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.spot.arn
    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 90
    }
  }

  tags = merge(
    {
      Name = format("spot-ecs-%s", var.project_name)
    },
    var.common_tags
  )
}