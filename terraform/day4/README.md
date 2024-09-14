# Linuxtips course: ECS demo application and autoscaling

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
$ docker pull fidelissauro/chip:latest
$ docker tag fidelissauro/chip:latest "$IMG":latest
$ docker push "$IMG":latest
```

Testing the application:
```bash
$ export ALB_DNS=<your alb dns name>
$ curl -s -i $ALB_DNS/version -H "Host: linuxtips.mydomain.fake"
HTTP/1.1 200 OK
Date: Sat, 14 Sep 2024 21:13:11 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 16
Connection: keep-alive

{"version":"v2"}
```

Load test using [k6](https://k6.io/):

```bash
$ k6 run -e MY_HOSTNAME=$ALB_DNS sample-k6.js  
```

Cleanup:

```bash
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
$ cd ../day2
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
$ cd ../day1
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
```

