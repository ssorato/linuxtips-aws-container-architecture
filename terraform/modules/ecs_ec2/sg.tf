resource "aws_security_group" "vpc_sg" {
  name   = format("vpc-sg-%s", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    {
      Name = format("vpc-sg-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "vpc_ingress" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "ingress"
  description       = "Enable ingress traffic to the VPC"
  security_group_id = aws_security_group.vpc_sg.id
  cidr_blocks       = [data.aws_vpc.main.cidr_block]
}
