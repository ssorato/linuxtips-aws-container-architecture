# Linuxtips course: ECS demo application

Requirements:

* the [day 1](../day1/README.md) network infrastructure.
* the [day 2](../day2/README.md) ECS infrastructure.

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
