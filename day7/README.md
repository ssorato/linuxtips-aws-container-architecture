# Linuxtips course: ECS with Elastic File System

Creation of AWS infrastructure, construction of docker image and submission to ECR using GitHub Actions pipeline.

Requirements:

* the [day 1](../day1/README.md) network infrastructure.
* the [day 6](../day6/README.md#ecs-cluster) ECS cluster

## ECS application

### Manually deploy

Build the application and push image to the ECR:

```bash
$ export AWS_ACCOUNT=<your AWS account id>
$ cd app
$ go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.59.1
$ golangci-lint -v run ./... -E errcheck
$ aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com
$ aws ecr create-repository --repository-name "linuxtips/linuxtips-app"
$ docker buildx build --platform linux/amd64 -t app . 
$ docker tag app:latest $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/linuxtips/linuxtips-app:v7
$ docker push $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/linuxtips/linuxtips-app:v7
$ docker logout $AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com
$ cd ..
```

Create the files:
* `terraform/ecs_app/environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/ecs_app/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
$ cd terraform/ecs_app
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars -var container_image=$AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/linuxtips/linuxtips-app:v7
$ terraform apply -var-file=environment/dev/terraform.tfvars -var container_image=$AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/linuxtips/linuxtips-app:v7
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

See the [workflow](../master/.github/workflows/ecs-app.yml)

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
Date: Sat, 12 Oct 2024 13:16:23 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 2
Connection: keep-alive

v7

$ curl -s -i $ALB_DNS/healthcheck -H "Host: linuxtips.mydomain.fake"
HTTP/1.1 200 OK
Date: Sat, 12 Oct 2024 13:16:50 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 2
Connection: keep-alive

ok
```

##  Testing the EFS

Get files list:

```bash
$ curl -s -i $ALB_DNS/files -H "Host: linuxtips.mydomain.fake"
HTTP/1.1 200 OK
Date: Sat, 12 Oct 2024 13:17:59 GMT
Content-Type: application/json
Content-Length: 14
Connection: keep-alive

{"files":null}
```

Create a file:

```bash
$ curl -s -X POST $ALB_DNS/files -H "Host: linuxtips.mydomain.fake" -d 'Linux Tips is top!!!'
{"file":"/mnt/efs/fec549f2-1aa8-4b85-acd2-9964440f15f7.txt","message":"File sucessful saved"}
```

Get the created file:

```bash
$ curl -s $ALB_DNS/files -H "Host: linuxtips.mydomain.fake" | jq
{
  "files": [
    "fec549f2-1aa8-4b85-acd2-9964440f15f7.txt"
  ]
}

$ curl -s $ALB_DNS/files/d5c4676c-d1aa-4a5d-978c-18f7f7deb960 -H "Host: linuxtips.mydomain.fake"
Linux Tips is top!!!
```
_The files list is always the same for each requistion; that's each ecs task reads from same shared filesystem_

## Cleanup

### Manually cleanup ECS application

```bash
$ export ECR_REPO="linuxtips/linuxtips-app"
$ cd terraform/ecs_app
$ terraform destroy -var-file=environment/dev/terraform.tfvars -var container_image=$AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/linuxtips/linuxtips-app:v7
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../..
$ aws ecr delete-repository --repository-name $ECR_REPO --force
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

See the [workflow](../master/.github/workflows/ecs-app-destroy.yml)

The above workflow is trigged manually.

### Final cleanup

```bash
$ cd ../day6/terraform/ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../../../day1 
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day7
```
# References

[Configuring Amazon EFS file systems for Amazon ECS using the console](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/tutorial-efs-volumes.html)
