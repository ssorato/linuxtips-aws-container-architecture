resource "aws_efs_file_system" "main" {
  creation_token   = format("%s-efs-%s", var.ecs_service.name, var.project_name)
  performance_mode = "generalPurpose"

  tags = merge(
    {
      Name = format("%s-efs-%s", var.ecs_service.name, var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group" "efs" {
  name        = format("%s-efs-%s-sg", var.ecs_service.name, var.project_name)
  description = format("ECS service %s security group in the project %s", var.ecs_service.name, var.project_name)
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  tags = merge(
    {
      Name = format("%s-efs-%s-sg", var.ecs_service.name, var.project_name)
    },
    var.common_tags
  )
}

#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# Avoid using the ingress and egress arguments of the aws_security_group resource to configure in-line rules
resource "aws_vpc_security_group_ingress_rule" "efs_ingress" {
  security_group_id = aws_security_group.efs.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 2049
  to_port     = 2049
  ip_protocol = "tcp"

  tags = merge(
    {
      Name = format("%s-efs-%s-sg-ingress", var.ecs_service.name, var.project_name)
    },
    var.common_tags
  )
}

resource "aws_vpc_security_group_egress_rule" "efs_egress" {
  security_group_id = aws_security_group.efs.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = merge(
    {
      Name = format("%s-efs-%s-sg-egress", var.ecs_service.name, var.project_name)
    },
    var.common_tags
  )
}

resource "aws_efs_mount_target" "efs_mount_subnet" {
  count          = length(data.aws_ssm_parameter.private_subnet)
  file_system_id = aws_efs_file_system.main.id
  subnet_id      = data.aws_ssm_parameter.private_subnet[count.index].value
  security_groups = [
    aws_security_group.efs.id
  ]
}
