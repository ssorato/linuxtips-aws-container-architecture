# Linuxtips course: ECS with API Gateway

## Network

Create the files:
* `terraform/network/environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/network/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ cd terraform/network
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars
$ terraform apply -var-file=environment/dev/terraform.tfvars
$ cd ../..
```

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

## API Gateway

Create the files:
* `terraform/ecs_api_gateway/environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/ecs_api_gateway/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ cd terraform/ecs_api_gateway
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars
$ terraform apply -var-file=environment/dev/terraform.tfvars

$ export API_URL=<your health_api_invoke_url>
$ export API_KEY=<yout api key>
$ cd ../ecs_health_api_lab
```

## ECS health-api application 

See [README](terraform/ecs_health_api_lab/README.md)

## Cleanup

```bash
$ cd terraform/ecs_api_gateway
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../network
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../..
```

## References

[How do I troubleshoot HTTP 403 errors from API Gateway?](https://repost.aws/knowledge-center/api-gateway-troubleshoot-403-forbidden)
