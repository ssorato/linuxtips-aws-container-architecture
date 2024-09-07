resource "aws_iam_role" "ecs_asg_role" {
  name = format("%s-instance-profile", var.project_name)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = merge(
    {
      Name = format("%s-instance-profile", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_iam_role_policy_attachment" "ec2_role" {
  role       = aws_iam_role.ecs_asg_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ecs_asg_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ecs_asg_instance_profile" {
  name = format("instance-profile-%s", var.project_name)
  role = aws_iam_role.ecs_asg_role.name

  tags = merge(
    {
      Name = format("instance-profile-%s", var.project_name)
    },
    var.common_tags
  )
}