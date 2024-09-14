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

Cleanup:

```bash
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
$ cd ../day1
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
```

# Tip

Show sensitive values in plan:

```bash
$ terraform plan -var-file=enviroment/dev/terraform.tfvars -out=tfplan
$ terraform show -json tfplan | jq
```

Get AMI for ECS containers:

```bash
$ aws ssm get-parameters \
    --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended
```

See also [Calling the ECS optimized AMI public parameter](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ecs.html)

