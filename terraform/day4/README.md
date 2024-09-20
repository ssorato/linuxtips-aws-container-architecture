# Linuxtips course: ECS demo application and autoscaling

Requirements:

* the [day 1](../day1/README.md) network infrastructure.
* the [day 2](../day2/README.md) ECS infrastructure.
* Docker running on the host where the Terraform runs, due to the provider `kreuzwerker/docker`


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

ECR image:

We are using `fidelissauro/chip:latest`. The image is pushed to the ECR using terraform.

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
# scale_type = cpu
$ k6 run -e MY_HOSTNAME=$ALB_DNS load_test/autoscaling-cpu-k6.js
# scale_type = cpu_tracking
$ k6 run -e MY_HOSTNAME=$ALB_DNS load_test/autoscaling-tracking-cpu-k6.js
# scale_type = requests_tracking
$ k6 run -e MY_HOSTNAME=$ALB_DNS load_test/autoscaling-tracking-requests-k6.js
```
see also [Monitor Amazon ECS using CloudWatch](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-metrics.html).

Cleanup:

```bash
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
$ cd ../day2
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
$ cd ../day1
$ terraform destroy -var-file=enviroment/dev/terraform.tfvars
```
