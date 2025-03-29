# Linuxtips course: Elastic Kubernetes Service - AWS Load Balancer Controller

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with AWS Load Balancer Controller

In this implementation, applications that cannot deal with instability will be managed by Fargate ( namespaces _kube-system_ and _karpenter_ ) ​​and the rest by Karpenter.

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-albc/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-albc/environment/dev/terraform.tfvars`:
  * your terraform variables values
    * update `route53` variable in order to add route53 entry with domain certificare.
    ```

Terraform:

```bash
cd terraform/eks-albc
terraform init -backend-config=environment/dev/backend.tfvars
terraform validate
terraform plan -var-file=environment/dev/terraform.tfvars
terraform apply -var-file=environment/dev/terraform.tfvars
cd ../..
```

### Kubeconfig

```bash
aws eks update-kubeconfig --region us-east-1 --name linuxtips-cluster --kubeconfig ~/.kube/linuxtips-cluster --alias linuxtips-cluster

export KUBECONFIG=~/.kube/linuxtips-cluster
kubectl cluster-info 
kubectl get nodes -o custom-columns=NAME:.metadata.name,CAPACITY_TYPE:.metadata.labels.capacity/type,ARCH:.metadata.labels.capacity/arch,OS::.metadata.labels.capacity/os
```

### Network load balancer

Review the [`chip_nlb.yaml`](chip_nlb.yaml) file.

```bash
kubectl apply -f chip_nlb.yaml
```

Test the NLB:

```bash
export MY_ALB_DNS_NAME=`aws elbv2 describe-load-balancers --names chip-nlb --query 'LoadBalancers[*].[DNSName]' --output text`
# export MY_ALB_DNS_NAME=`kubectl -n chip  get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].hostname}"` # alternative
curl -si http://$MY_ALB_DNS_NAME:8080/version
```

Cleanup:

```bash
kubectl delete -f chip_nlb.yaml
```

### Application load balancer

Review the [`chip_alb.yaml`](chip_alb.yaml) file.

```bash
kubectl apply -f chip_alb.yaml
```

Add DNS entry to link you domain to the NLB:

```bash
export MY_DOMAIN_HOSTED_ZONE_ID=<your domain hosted zone id>
export APP_DNS_NAME=`kubectl -n chip get ingress -o jsonpath="{.items[0].spec.rules[0].host}"`
export MY_ALB_DNS_NAME=`aws elbv2 describe-load-balancers --names chip-alb --query 'LoadBalancers[*].[DNSName]' --output text`
export LB_HOSTED_ZONE_ID=`aws elbv2 describe-load-balancers --names chip-alb --query 'LoadBalancers[*].[CanonicalHostedZoneId]' --output text`
cat << EOT > dns_record.json
{  
  "Comment": "Creating Alias resource record sets in Route 53",
    "Changes": [
    {
    "Action": "UPSERT",
    "ResourceRecordSet": {
        "Name": "${APP_DNS_NAME}",
        "Type": "A",
        "AliasTarget": {
            "HostedZoneId": "${LB_HOSTED_ZONE_ID}",
            "DNSName": "dualstack.${MY_ALB_DNS_NAME}.",
            "EvaluateTargetHealth": false
        }
      }
    }
  ]
}
EOT
aws route53 change-resource-record-sets --hosted-zone-id $MY_DOMAIN_HOSTED_ZONE_ID --change-batch file://./dns_record.json
```

Test the ALB:

```bash
curl -si http://$APP_DNS_NAME/version 
```

Cleanup:

```bash
kubectl delete -f chip_alb.yaml

sed -i '' 's/UPSERT/DELETE/' dns_record.json
aws route53 change-resource-record-sets --hosted-zone-id $MY_DOMAIN_HOSTED_ZONE_ID --change-batch file://./dns_record.json
```

### Application load balancer with certificate

Review the [`chip_alb_acm.yaml`](chip_alb_acm.yaml) file.

```bash
kubectl apply -f chip_alb_acm.yaml
```

Add DNS entry to link you domain to the NLB:

```bash
export MY_DOMAIN_HOSTED_ZONE_ID=<your domain hosted zone id>
export APP_DNS_NAME=`kubectl -n chip get ingress -o jsonpath="{.items[0].spec.rules[0].host}"`
export MY_ALB_DNS_NAME=`aws elbv2 describe-load-balancers --names chip-alb --query 'LoadBalancers[*].[DNSName]' --output text`
export LB_HOSTED_ZONE_ID=`aws elbv2 describe-load-balancers --names chip-alb --query 'LoadBalancers[*].[CanonicalHostedZoneId]' --output text`
cat << EOT > dns_record.json
{  
  "Comment": "Creating Alias resource record sets in Route 53",
    "Changes": [
    {
    "Action": "UPSERT",
    "ResourceRecordSet": {
        "Name": "${APP_DNS_NAME}",
        "Type": "A",
        "AliasTarget": {
            "HostedZoneId": "${LB_HOSTED_ZONE_ID}",
            "DNSName": "dualstack.${MY_ALB_DNS_NAME}.",
            "EvaluateTargetHealth": false
        }
      }
    }
  ]
}
EOT
aws route53 change-resource-record-sets --hosted-zone-id $MY_DOMAIN_HOSTED_ZONE_ID --change-batch file://./dns_record.json
```

Test the ALB:

```bash
curl -si https://$APP_DNS_NAME/version 
```

Cleanup:

```bash
kubectl delete -f chip_alb_acm.yaml

sed -i '' 's/UPSERT/DELETE/' dns_record.json
aws route53 change-resource-record-sets --hosted-zone-id $MY_DOMAIN_HOSTED_ZONE_ID --change-batch file://./dns_record.json
```

### Using an existing load balancer

See [TargetGroupBinding](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/targetgroupbinding/targetgroupbinding/)

Set the variable `create_nlb` as `true` in the [`terraform.tfvars`](terraform/eks-albc/environment/dev/terraform.tfvars)

Deploy again _day24_ infrastructure ( see above [Deploy EKS with AWS Load Balancer Controller](#deploy-eks-with-aws-load-balancer-controller) )

Review the [`chip_tgb.yaml`](chip_tgb.yaml) file.

```bash
kubectl apply -f chip_tgb.yaml
```

Test the NLB:

```bash
export MY_ALB_DNS_NAME=`aws elbv2 describe-load-balancers --names linuxtips-cluster-nlb --query 'LoadBalancers[*].[DNSName]' --output text`
curl -si http://$MY_ALB_DNS_NAME/healthcheck
```

Cleanup:

```bash
kubectl delete -f chip_tgb.yaml
```

### Cleanup

```bash
cd terraform/eks-albc
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

Remove log groups from CloudWatch:

```bash
export EKS_NAME=`grep project_name terraform/eks-albc/environment/dev/terraform.tfvars | cut -d"=" -f 2 | sed 's/[" ]//g'`
aws logs describe-log-groups --log-group-name-pattern $EKS_NAME --query 'logGroups[*].logGroupName' --output json | jq -r '.[]' |
while read LOG
do
  aws logs delete-log-group --log-group-name $LOG
done
```

## References

[AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/)



