resource "aws_sqs_queue" "health" {
  name                       = format("%s-health", var.project_name)
  delay_seconds              = 0
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 60

  tags = merge(
    {
      Name = format("%s-health", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_sqs_queue_policy" "health" {
  queue_url = aws_sqs_queue.health.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.health.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_dynamodb_table" "health" {
  name           = format("%s-health-data", var.project_name)
  hash_key       = "id"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    {
      Name = format("%s-health-data", var.project_name)
    },
    var.common_tags
  )
}


data "aws_iam_policy_document" "nutrition_role" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}


resource "aws_iam_role" "nutrition_role" {
  assume_role_policy = data.aws_iam_policy_document.nutrition_role.json
  name               = format("%s-nutrition", var.project_name)

  tags = merge(
    {
      Name = format("%s-nutrition", var.project_name)
    },
    var.common_tags
  )
}

data "aws_iam_policy_document" "nutrition_policy" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "sqs:*",
      "dynamodb:*",
    ]

    resources = [
      "*"
    ]

  }
}

resource "aws_iam_policy" "nutrition_policy" {
  name        = format("%s-nutrition", var.project_name)
  path        = "/"
  description = var.project_name

  policy = data.aws_iam_policy_document.nutrition_policy.json


  tags = merge(
    {
      Name = format("%s-nutrition", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_iam_policy_attachment" "nutrition" {
  name = "nutrition"
  roles = [
    aws_iam_role.nutrition_role.name
  ]

  policy_arn = aws_iam_policy.nutrition_policy.arn
}

resource "aws_eks_pod_identity_association" "nutrition" {
  cluster_name    = module.eks-keda.eks_cluster_name
  namespace       = "nutrition"
  service_account = "nutrition"
  role_arn        = aws_iam_role.nutrition_role.arn

  tags = merge(
    {
      Name = format("%s-nutrition", var.project_name)
    },
    var.common_tags
  )
}