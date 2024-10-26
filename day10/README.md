# Linuxtips course: ECS with Service Connect

Requirements:

* the [day 1](../day1/README.md) network infrastructure.

## ECS cluster

Create the files:
* `terraform/ecs/environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/ecs/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ cd terraform/ecs
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars
$ terraform apply -var-file=environment/dev/terraform.tfvars
$ cd ../..
```

## ECS health-api application 

See [README](terraform/ecs_health_api_lab/README.md)

## Cleanup

```bash
$ cd terraform/ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../../day1
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day10
```

