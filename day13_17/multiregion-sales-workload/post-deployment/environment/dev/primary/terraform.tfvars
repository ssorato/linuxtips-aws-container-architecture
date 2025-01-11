common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  day        = "ecs-final-project-vpc"
  step       = "multiregion-sales-workload"
}

project_name = "linuxtips-multiregion"

region_primary   = "us-east-1"
region_secondary = "us-east-2"

bucket_prefix_name = "sales-offload-datalake"

sqs_sns_name = "sales-processing"
