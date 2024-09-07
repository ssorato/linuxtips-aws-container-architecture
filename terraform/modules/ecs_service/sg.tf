resource "aws_security_group" "main" {
  name = format("%s-%s", var.ecs_name, var.ecs_service_name)

  vpc_id = var.vpc_id

  ingress {
    from_port = var.ecs_service_port
    to_port   = var.ecs_service_port
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

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
      Name = format("%s-%s", var.ecs_name, var.ecs_service_name)
    },
    var.common_tags
  )
}