# Linuxtips course: ECS with EC2

Requirements:

* the [day 1](../day1/README.md) network infrastructure.

Create the files:
* `enviroment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `enviroment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ terraform init -backend-config=enviroment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=enviroment/dev/terraform.tfvars
$ terraform apply -var-file=enviroment/dev/terraform.tfvars
```

# Tip

Show sensitive values in plan:

```bash
$ terraform plan -var-file=enviroment/dev/terraform.tfvars -out=tfplan
$ terraform show -json tfplan | jq
```