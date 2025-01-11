common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  project    = "ecs-final-project"
  step       = "multiregion-sales-workload"
}

cluster_name = "sales-cluster"
region       = "us-east-2"

bucket_prefix_name = "sales-offload-datalake"

sqs_processing_sales_config = {
  queue_name                    = "sales-processing"
  delay_seconds                 = 0
  max_message_size              = 262144
  message_retention_seconds     = 86400
  receive_wait_time_seconds     = 10
  visibility_timeout_seconds    = 60
  dlq_redrive_max_receive_count = 4
}

sales_table_name             = "sales-workload"
sales_idempotency_table_name = "sales-workload-idempotency"
parameter_store_state_name   = "/sales/site/state"


ssm_vpc_id           = "/linuxtips-multiregion/vpc/vpc_id"
ssm_private_subnet_1 = "/linuxtips-multiregion/vpc/private/us-east-2a"
ssm_private_subnet_2 = "/linuxtips-multiregion/vpc/private/us-east-2b"
ssm_private_subnet_3 = "/linuxtips-multiregion/vpc/private/us-east-2c"
ssm_alb              = "/sales-cluster/lb/internal/arn"
ssm_listener         = "/sales-cluster/lb/internal/http/listener"
ssm_listener_https   = "/sales-cluster/lb/internal/https/listener"

sales_dns_name = "sales.yourdomain.com"
