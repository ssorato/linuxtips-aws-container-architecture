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

## ECS application using EFS

This application will be reachable only using internal ALB.

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

#### Testing the application using internal ALB:

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

#### Testing the service discovery

```bash
$ ssh ec2-user@$BASTION_PUBLIC_IP host linuxtips-app.linuxtips.discovery.com
linuxtips-app.linuxtips.discovery.com has address 10.0.27.206
linuxtips-app.linuxtips.discovery.com has address 10.0.36.142
linuxtips-app.linuxtips.discovery.com has address 10.0.28.211
```

Each IP is the ECS service task IP registerd in the DNS (service discovery namespace zone); get service tasks IP:

```bash
$ export ECS_CLUSTERNAME=<your ecs cluster name>
$ for TASK_ARN in $(aws ecs list-tasks --cluster $ECS_CLUSTERNAME --query "taskArns" --output text)
do
  ENI=$(aws ecs describe-tasks --cluster $ECS_CLUSTERNAME --tasks $TASK_ARN --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text)
  aws ec2 describe-network-interfaces --network-interface-ids $ENI --query 'NetworkInterfaces[0].PrivateIpAddresses[0].PrivateIpAddress' --output text
done

10.0.27.206
10.0.28.211
10.0.36.142
```

## ECS pudim application 

_Pudim_ is _pudding_ in portugues ...

This application will be reachable only using public ALB.

Create the files:
* `terraform/ecs_app_pudim/environment/dev/backend.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/ecs_app_pudim/environment/dev/terraform.tfvars`:
  * your terraform variables values

### ECS pudim application

```bash
$ cd terraform/ecs_app_pudim
$ terraform init -backend-config=environment/dev/backend.tfvars
$ terraform validate
$ terraform plan -var-file=environment/dev/terraform.tfvars
$ terraform apply -var-file=environment/dev/terraform.tfvars
$ cd ../..
```

#### Testing the Pudim site

```bash
$ curl -s -i $ALB_DNS -H "Host: pudim.linuxtips.mydomain.fake" | grep title
    <title>Pudim</title>
```

Map on your local _hosts_:

```bash
<one public ALB IP> pudim.linuxtips.mydomain.fake
```

and in your browser open `http://pudim.linuxtips.mydomain.fake`

Pudim service is also registred in the Cloud Map service discovery.

```bash
$ aws servicediscovery list-services | jq -r '.Services[].Name'
linuxtips-app
pudim
```

## Cleanup

### ECS pudim application

```bash
$ cd terraform/ecs_app_pudim
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../..
```

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
