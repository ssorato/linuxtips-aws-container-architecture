# Linuxtips course: Elastic Kubernetes Service - Argo Rollouts

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with Nginx Ingress Controller

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

### Prometheus web UI

```bash
kubectl -n prometheus port-forward svc/prometheus-operated 9090:9090
```

and open the URL _http://localhost:9090_

### Grafana

Loggin into URL _https://grafanalab.yourdomain.com_

### Jaeger

Loggin into URL _https://jaegeerlab.yourdomain.com_

### Kiali

Loggin into URL _https://kialilab.yourdomain.com_

### Argo Rollouts dashboard

Loggin into URL _https://argolab.yourdomain.com_

### Chip

Initial deploy:

```bash
export CHIP_DOMAIN="chip.`echo $MY_WILDCARD_DOMAIN | sed 's/*.//'`"
cat chip-lab/*.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

#### Argo Rollouts

##### Simple rollout

```bash
kubectl apply -f chip-lab/argo-rollouts/rollout.yaml

kubectl -n chip get rollouts
```

Monitor the app version:

```bash
while true
do
  curl -s https://$CHIP_DOMAIN/version
  echo
done
```

Check also the Argo Rollouts dashboard

#### Canary release with manual progress

[Canary Deployment Strategy](https://argoproj.github.io/argo-rollouts/features/canary/)

Promote to `v2`:

```bash
kubectl apply -f chip-lab/argo-rollouts/canary_manual_progression_rollout.yaml
```

#### Canary release with time progress

Promote to `v3`:

```bash
kubectl apply -f chip-lab/argo-rollouts/canary_time_progression_rollout.yaml
```

#### Canary release with time progress and metrics analysis

[Analysis & Progressive Delivery](https://argoproj.github.io/argo-rollouts/features/analysis/)

Promote to `v4`:

```bash
kubectl apply -f chip-lab/argo-rollouts/canary_metrics_progression_rollout.yaml
```

Promote to `v5` (_chaos enabled_):

```bash
kubectl apply -f chip-lab/argo-rollouts/canary_metrics_progression_rollout_chaos.yaml
```

#### Blue Green deployment

[BlueGreen Deployment Strategy](https://argoproj.github.io/argo-rollouts/features/bluegreen/)

>>>  Blue is running the current application version and _Green_ is running the new application version.

Clenaup: 

```bash
kubectl delete ns chip
cat chip-lab/*.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

Delploy `v6`:

```bash
cat chip-lab/argo-rollouts/blue_green_manual_rollout.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

Monitor the app version:

```bash
while true
do
  curl -s https://$CHIP_DOMAIN/version
  echo
done
```

##### Blue Green deployment with manual promotion

Delploy `v7`:

```bash
cat chip-lab/argo-rollouts/blue_green_manual_rollout_v7.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

Check the preview version

```bash
kubectl run curl-debug --rm -i --tty --image alpine/curl --command -- sh                                                       

/ # curl http://chip-green.chip.svc.cluster.local:8080/version && echo
{"version":"v7"}
/ # curl http://chip.chip.svc.cluster.local:8080/version && echo
{"version":"v6"}
/ # exit
```

Now you can promote the _preview_ version

##### Blue Green deployment with automatic promotion

Promote to `v8`:

```bash
cat chip-lab/argo-rollouts/blue_green_automatic_rollout_v8.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

##### Blue Green deployment with warm-up

Promote to `v9`:

```bash
cat chip-lab/argo-rollouts/blue_green_warmup_rollout.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

##### Blue Green deployment with metrics

Promote to `v10`:

```bash
cat chip-lab/argo-rollouts/blue_green_metrics_rollout.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
```

#### Cleanup Chip

```bash
kubectl delete ns chip
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

[Argo Rollouts](https://argoproj.github.io/rollouts/)

[Argo Rollouts Chart](https://artifacthub.io/packages/helm/argo/argo-rollouts)

[Argo Rollouts  Controller Metrics](https://argoproj.github.io/argo-rollouts/features/controller-metrics/)

[Argo Rollouts dashboard](https://github.com/argoproj/argo-rollouts/blob/master/examples/dashboard.json)


