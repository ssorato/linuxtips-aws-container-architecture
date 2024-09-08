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

Login into the ECR and create the image, then push to the ECR:

```bash
$ export IMG=<your ecr uri>
$ docker build -t "$IMG":latest ../../app
$ docker push "$IMG":latest
```

Testing the application:
```bash
$ export ALB_DNS=<your alb dns name>
$ curl -s -i $ALB_DNS/version -H "Host: linuxtips.mydomain.fake"
HTTP/1.1 200 OK
Date: Sat, 07 Sep 2024 21:31:50 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 2
Connection: keep-alive

v7
```
