# Linuxtips course: ECS with Secret Manager and Parameter Store

Using Secret Manager and Parameter Store in an ECS application

Requirements:

* the [day 1](../day1/README.md) network infrastructure.
* the [day 6](../day6/README.md#ecs-cluster) ECS cluster

## ECS application

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
$ curl -s $ALB_DNS/version -H "Host: linuxtips.mydomain.fake"
v7

$ curl -s $ALB_DNS/printenv -H "Host: linuxtips.mydomain.fake" | jq | egrep "VAR_FROM|GOOD|FOO"
  "FOO=BAR",
  "GOOD=BAD",
  "VAR_FROM_SECRETS_MANAGER=Sample secret from secret manager v1",
  "VAR_FROM_PARAMETERS_STORE=Sample from parameters store v1",
```

### Cleanup ECS application using GitHub Action pipeline

Execute the GitHub Action _ECS app destroy_ and select _day8_

The [workflow](../master/.github/workflows/ecs-app-destroy.yml) is trigged manually.

## Final cleanup

```bash
$ cd ../day6/terraform/ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../../../day1 
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day8
```

# Tip

[Delete an AWS Secrets Manager secret](https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_delete-secret.html)

>>> Because of the critical nature of secrets, AWS Secrets Manager intentionally makes deleting a secret difficult. Secrets Manager does not immediately delete secrets. Instead, Secrets Manager immediately makes the secrets inaccessible and scheduled for deletion after a recovery window of a minimum of seven days. Until the recovery window ends, you can recover a secret you previously deleted.

List sectets in Secrets Manager:

```bash
$ aws secretsmanager list-secrets --include-planned-deletion --output json | jq 
```

Force delete a secret:

```bash
$ aws secretsmanager delete-secret --secret-id linuxtips-app-ecs-task-secret --force-delete-without-recovery
```
