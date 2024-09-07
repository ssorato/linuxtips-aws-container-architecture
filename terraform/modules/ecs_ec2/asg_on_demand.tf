resource "aws_autoscaling_group" "on_demand" {
  name_prefix = format("on-demand-asg-%s", var.project_name)

  vpc_zone_identifier = data.aws_ssm_parameter.private_subnet[*].value

  desired_capacity = var.ecs.on_demand.desired_size
  max_size         = var.ecs.on_demand.max_size
  min_size         = var.ecs.on_demand.min_size

  launch_template {
    id      = aws_launch_template.on_demand.id
    version = aws_launch_template.on_demand.latest_version
  }

  tag {
    key                 = "Name"
    value               = format("on-demand-asg-%s", var.project_name)
    propagate_at_launch = true
  }

  # review: change to common_tags
  tag {
    key                 = "sandbox"
    value               = "linuxtips"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }

}

resource "aws_launch_template" "on_demand" {
  name_prefix = format("asg-template-on-demand-%s", var.project_name)
  image_id    = var.ecs.nodes_ami

  instance_type = var.ecs.node_instance_type

  vpc_security_group_ids = [
    aws_security_group.vpc_sg.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_asg_instance_profile.name
  }

  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.ecs.node_volume_size_gb
      volume_type = var.ecs.node_volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name = format("asg-template-on-demand-%s", var.project_name)
      },
      var.common_tags
    )
  }

  user_data = base64encode(templatefile("${path.module}/templates/user-data.tpl", {
    CLUSTER_NAME = var.project_name
  }))
}
