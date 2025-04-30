# Linuxtips course: Elastic Kubernetes Service - Argo CD and ChartMuseum

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS

In this implementation, applications that cannot deal with instability will be managed by Fargate ( namespaces _kube-system_ and _karpenter_ ) ​​and the rest by Karpenter.

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-argo/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-argo/environment/dev/terraform.tfvars`:

Terraform:

```bash
cd terraform/eks-argo
export MY_WILDCARD_DOMAIN=<your wildcard domain> # *.mydomain.com
export MY_ROUTE53_HOSTED_ZONEID=<your route53 hosted zone id>
export TF_VAR_route53="{ dns_name = \"$MY_WILDCARD_DOMAIN$\", hosted_zone = \"$MY_ROUTE53_HOSTED_ZONEID\" }"
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

### ArgoCD

Get `admin` password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Loggin into URL _https://argocdlab.yourdomain.com_

#### Chip app

```bash
export MY_DOMAIN=`echo $MY_WILDCARD_DOMAIN | sed 's/*.//'`
kubectl apply -f chip-argocd-project.yaml
cat chip-applicationset.yaml | sed "s/yourdomain.com/$MY_DOMAIN/" | kubectl apply -f -
```

Monitor the app version:

```bash
while true
do
  curl -s https://chip.$MY_DOMAIN/version
  echo
done
```

Update to `v2`:

```bash
cat chip-applicationset.yaml | sed "s/yourdomain.com/$MY_DOMAIN/" | sed 's/value: v1/value: v2/' | kubectl apply -f -
```

Cleanup:

```bash
kubectl delete -f chip-applicationset.yaml
# wait for resources to be deleted
kubectl apply -f chip-argocd-project.yaml 
```

#### Helath API

```bash
kubectl apply -f health-api-argocd-project.yaml
cat health-api-applicationset.yaml | sed "s/yourdomain.com/$MY_DOMAIN/" | kubectl apply -f -
```

Monitor the app version:

```bash
while true
do
  curl -s https://health.$MY_DOMAIN/version
  echo
done
```

Cleanup:

```bash
kubectl delete -f health-api-applicationset.yaml
# wait for resources to be deleted
kubectl apply -f health-api-argocd-project.yaml 
```

### Cleanup

[Unable to delete nodes after uninstalling Karpenter](https://karpenter.sh/docs/troubleshooting/#unable-to-delete-nodes-after-uninstalling-karpenter)

Uanble to remove all nodes created by Karpenter; Terraform is unable to completely remove Prometheus before remove Karpernter. Workaround:

```bash
helm uninstall prometheus -n prometheus
```

Wait until all Karpenter nodes are deleted:

```bash
kubectl get nodes -l karpenter.sh/nodepool=prometheus
kubectl get nodepool prometheus
```

Cleanup: 

```bash
cd terraform/eks-argo
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

Remove log groups from CloudWatch:

```bash
export EKS_NAME=`grep project_name terraform/eks-argo/environment/dev/terraform.tfvars | cut -d"=" -f 2 | sed 's/[" ]//g'`
aws logs describe-log-groups --log-group-name-pattern $EKS_NAME --query 'logGroups[*].logGroupName' --output json | jq -r '.[]' |
while read LOG
do
  aws logs delete-log-group --log-group-name $LOG
done
```

Remove the [day 18](../day18/README.md) EKS networking

See also [karpenter does not delete aws network interface after scale down #5582](https://github.com/aws/karpenter-provider-aws/issues/5582)

## References

[Argo CD](https://argoproj.github.io/cd/)

[Argo Rollout Extension](https://github.com/argoproj-labs/rollout-extension)

