resource "aws_ssm_parameter" "vpc" {
  name  = format("/%s/vpc/vpc_id", var.project_name)
  type  = "String"
  value = aws_vpc.main.id

  tags = merge(
    {
      Name = format("/%s/vpc/vpc_id", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "private_subnets" {
  count = length(aws_subnet.private_subnet)
  name  = format("/%s/vpc/subnet_private_%s_id", var.project_name, replace(aws_subnet.private_subnet[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.private_subnet[count.index].id

  tags = merge(
    {
      Name = format("/%s/vpc/subnet_private_%s_id", var.project_name, replace(aws_subnet.private_subnet[count.index].availability_zone, "-", "_"))
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "public_subnets" {
  count = length(aws_subnet.public_subnet)
  name  = format("/%s/vpc/subnet_public_%s_id", var.project_name, replace(aws_subnet.public_subnet[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.public_subnet[count.index].id

  tags = merge(
    {
      Name = format("/%s/vpc/subnet_public_%s_id", var.project_name, replace(aws_subnet.public_subnet[count.index].availability_zone, "-", "_"))
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "database_subnets" {
  count = length(aws_subnet.database_subnet)
  name  = format("/%s/vpc/subnet_database_%s_id", var.project_name, replace(aws_subnet.database_subnet[count.index].availability_zone, "-", "_"))
  type  = "String"
  value = aws_subnet.database_subnet[count.index].id

  tags = merge(
    {
      Name = format("/%s/vpc/subnet_database_%s_id", var.project_name, replace(aws_subnet.database_subnet[count.index].availability_zone, "-", "_"))
    },
    var.common_tags
  )
}

