# Linuxtips course: ECS demo application using Fargate

Requirements:

* the [day 1](../day1/README.md) network infrastructure.
* Docker running on the host where the Terraform runs, due to the provider `kreuzwerker/docker`


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

We are using `fidelissauro/chip:latest`. The image is pushed to the ECR using terraform.

Testing the application:
```bash
$ export ALB_DNS=<your alb dns name>
$ curl -s -i $ALB_DNS/version -H "Host: linuxtips.mydomain.fake"
HTTP/1.1 200 OK
Date: Sat, 21 Sep 2024 12:28:18 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 16
Connection: keep-alive

{"version":"v2"}
```

Cleanup:

```bash
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ cd ../day1
$ terraform destroy -var-file=environment/dev/terraform.tfvars
```

# Tip

[AWS Fargate Pricing Calculator](https://cloudtempo.dev/fargate-pricing-calculator)
