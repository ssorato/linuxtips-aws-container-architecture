# Linuxtips course: ECS using Fargate and pipeline using GitHub Actions

Creation of AWS infrastructure, construction of docker image and submission to ECR using GitHub Actions pipeline.

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
* `terraform/ecs/environment/dev/backend.tfvars`:
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

## ECS application

### Manually deploy

Create the files:
* `terraform/ecs/environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/ecs/environment/dev/backend.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ cd terraform/ecs_app
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars
$ terraform apply -var-file=environment/dev/terraform.tfvars
$ cd ../..
```

### Alternative: ECS application using local pipeline

This pipeline deploys the ECS application

Using [Task](https://taskfile.dev):

```bash
$ task --list-all
task: Available tasks for this project:
* app-ci:               Application CI
* build-push-app:       Build application and push container image
* default:              Default task: execute wait_deploy
* destroy:              Destroy ecs
* infra-cd:             Infrastructure CD
* infra-ci:             Infrastructure CI
* wait_deploy:          Waiting for deployment to complete

$ task
```

### Alternative: ECS application using GitHub Action pipeline

See the [workflow](../../.github/workflows/day6.yml)

The above workflow is trigged on push changes in the [app](app) folder.

Add the following secrets in the GitHub repository:
  * `AWS_ACCOUNT`: AWS account id
  * `AWS_ACCESS_KEY_ID`: AWS account access key  
  * `AWS_SECRET_ACCESS_KEY`: AWS account access key secret
  * `DYNAMODB_TABLE_NAME`: tfstate lock dynamodb table name
  * `S3_BUCKET_NAME`: tfstate bucket name
  * `S3_KEY_ROOT_PATH`: tfstate bucket key root path
  * `ALB_INGRESS_CIDR_ENABLED`: CIDR enabled to access to the ALB


##  Testing the application

```bash
$ export ALB_DNS=<your alb dns name>
$ curl -s -i $ALB_DNS/version -H "Host: linuxtips.mydomain.fake"
HTTP/1.1 200 OK
Date: Sat, 05 Oct 2024 14:11:01 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 2
Connection: keep-alive

v6
```

##  Testing the GitHub Action pipeline

Monitoring the application version:

```bash
$ while true
do
curl -s  $ALB_DNS/version -H "Host: linuxtips.mydomain.fake"
echo
done
```

Change the application version in the [main.go](app/main.go) file and observe the monitoring ouput.

## Cleanup

### Manually cleanup ECS application

```bash
$ cd terraform/ecs_app
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../..
```

### Alternative: manually cleanup ECS application using local pipeline

This pipeline deploys the ECS application

Using [Task](https://taskfile.dev):

```bash
$ task --list-all
task: Available tasks for this project:
* app-ci:               Application CI
* build-push-app:       Build application and push container image
* default:              Default task: execute wait_deploy
* destroy:              Destroy ecs
* infra-cd:             Infrastructure CD
* infra-ci:             Infrastructure CI
* wait_deploy:          Waiting for deployment to complete

$ task destroy
```

### Alternative: cleanup ECS application using GitHub Action pipeline

See the [workflow](../../.github/workflows/day6-destroy.yml)

The above workflow is trigged manually.

### Final cleanup

```bash
$ cd terraform/ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../../../day1
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day6
```

# Tip

[AWS Fargate Pricing Calculator](https://cloudtempo.dev/fargate-pricing-calculator)

