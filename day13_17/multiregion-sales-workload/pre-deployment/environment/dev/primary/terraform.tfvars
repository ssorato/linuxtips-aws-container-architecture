common_tags = {
  created_by = "terraform-linuxtips-aws-container-architecture"
  sandbox    = "linuxtips"
  project    = "ecs-final-project"
  step       = "multiregion-sales-workload"
}

project_name     = "sales"
region_primary   = "us-east-1"
region_secondary = "us-east-2"

active_states = {
  us-east-1 = "ACTIVE"
  us-east-2 = "PASSIVE" # or ACTIVE
}

dynamodb_idempotency = {
  name         = "sales-workload-idempotency"
  billing_mode = "PROVISIONED"

  point_in_time_recovery = true

  read_min                 = 10
  read_max                 = 100
  read_autoscale_threshold = 80

  write_min                 = 10
  write_max                 = 100
  write_autoscale_threshold = 80
}

dynamodb_sales = {
  name         = "sales-workload"
  billing_mode = "PROVISIONED"

  point_in_time_recovery = true

  read_min                 = 10
  read_max                 = 100
  read_autoscale_threshold = 80

  write_min                 = 10
  write_max                 = 100
  write_autoscale_threshold = 80
}
