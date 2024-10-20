# Linuxtips course: ECS with internal ALB, advance routing and Service Discover

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

### Testing ALB

Testing public ALB

```bash
$ export ALB_DNS=<your alb dns name>
$ curl -s $ALB_DNS -H "Host: linuxtips.mydomain.fake"
LinuxTips
```

Testing internal ALB

```bash
$ export BASTION_PUBLIC_IP=<yout bastion vm public ip>
$ ssh ec2-user@$BASTION_PUBLIC_IP curl -s app.linuxtips.internal.com
LinuxTips internal
```

## ECS application

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


### ECS application using local pipeline

This pipeline deploys the ECS application

Using [Task](https://taskfile.dev):

```bash
$ task --list-all
task: Available tasks for this project:
* app-ci:               Application CI
* build-push-app:       Build application and push container image
* default:              Default task: execute wait_deploy
* destroy:              Destroy ecs app
* infra-cd:             Infrastructure CD
* infra-ci:             Infrastructure CI
* wait_deploy:          Waiting for deployment to complete

$ task
```

Testing the application using internal ALB:

```bash
$ ssh ec2-user@$BASTION_PUBLIC_IP curl -s app.linuxtips.internal.com/version
v12
```

```bash
$ ssh ec2-user@$BASTION_PUBLIC_IP 'curl -s -X POST app.linuxtips.internal.com/files -d "Linux Tips is top!!!"' 
{"file":"/mnt/efs/12f68937-ac26-4de3-8c80-f5f9ac7e071b.txt","message":"File sucessful saved"}

$ ssh ec2-user@$BASTION_PUBLIC_IP curl -s app.linuxtips.internal.com/files
{"files":["12f68937-ac26-4de3-8c80-f5f9ac7e071b.txt"]}

$ ssh ec2-user@$BASTION_PUBLIC_IP curl -s app.linuxtips.internal.com/files/12f68937-ac26-4de3-8c80-f5f9ac7e071b
Linux Tips is top!!!
```

## Cleanup

### ECS application using local pipeline

```bash
$ task destroy
```

### Final cleanup

```bash
$ cd terraform/ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../../day1
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day9
```
