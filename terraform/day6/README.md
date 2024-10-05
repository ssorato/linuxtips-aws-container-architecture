# Linuxtips course: ECS using Fargate and pipeline using GitHub Actions

Creation of AWS infrastructure, construction of docker image and submission to ECR using GitHub Actions pipeline.

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

ECR image:

The GitHub Action build the image and push to the ECR.

Testing the application:
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

Cleanup:

```bash
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ cd ../day1
$ terraform destroy -var-file=environment/dev/terraform.tfvars
```

# Tip

[AWS Fargate Pricing Calculator](https://cloudtempo.dev/fargate-pricing-calculator)

# Local pipeline

Using [Task](https://taskfile.dev):

```bash
$ task --list-all
task: Available tasks for this project:
* app-ci:            Application CI
* build-app:         Build application
* default:           Default task: execute wait_deploy
* destroy:           
* infra-cd:          Infrastructure CD
* infra-ci:          Infrastructure CI
* wait_deploy:       Waiting for deployment to complete

$ task
```