# Linuxtips course: ECS Blue/Green and Canary with CodeDeploy

[Working with deployment configurations in CodeDeploy](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html)

Requirements:

* the [day 11](../day11/README.md) network infrastructure.
* the [day 11](../day11/README.md) ECS cluster.
* the [day 11](../day11/README.md) API Gateway.

## ECS health-api application 

See [README](terraform/ecs_health_api_lab/README.md)

## Cleanup

```bash
$ cd ../day11/terraform/ecs
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../day11/terraform/network
$ terraform destroy -var-file=environment/dev/terraform.tfvars
$ rm -r .terraform.lock.hcl 
$ rm -rf .terraform
$ cd ../..
```

# Note about CodeDeploy and Service Connect

CodeDeploy blue/green not works with Service Connect. Set `use_service_connect` to `false`.
