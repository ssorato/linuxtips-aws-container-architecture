# Linuxtips course: ECS with EC2

Requirements:

* the [day 1](../day1/README.md) network infrastructure.

Create the files:
* `environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars
$ terraform apply -var-file=environment/dev/terraform.tfvars
```

Cleanup:

```bash
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day1
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
```

# Tip

Show sensitive values in plan:

```bash
$ terraform plan -var-file=environment/dev/terraform.tfvars -out=tfplan
$ terraform show -json tfplan | jq
```

Get AMI for ECS containers:

```bash
$ aws ssm get-parameters \
    --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended
```

See also [Calling the ECS optimized AMI public parameter](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ecs.html)

