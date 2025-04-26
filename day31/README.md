# Linuxtips course: Elastic Kubernetes Service - Keda Autoscaler

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with Nginx Ingress Controller

In this implementation, applications that cannot deal with instability will be managed by Fargate ( namespaces _kube-system_ and _karpenter_ ) ​​and the rest by Karpenter.

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-keda/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-keda/environment/dev/terraform.tfvars`:

Terraform:

```bash
cd terraform/eks-keda
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

### Chip

```bash
export CHIP_DOMAIN="chip.`echo $MY_WILDCARD_DOMAIN | sed 's/*.//'`"
kubectl apply -f chip-lab
cat chip-lab/02_istio_gateway.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -
cat chip-lab/03_istio_virtualservice.yaml | sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -

curl -s https://$CHIP_DOMAIN/version
```

#### Tesing Keda autoscaling with Chip app based on cpu

```bash
kubectl apply -f chip-lab/keda/high_cpu.yaml
```

```bash
while true
do
  curl -s https://$CHIP_DOMAIN/burn/cpu
  echo
done
```

Monitor the ammount of pods:

```bash
kubectl -n chip get pods -w
```

Cleanup:

```bash
kubectl delete -f chip-lab/keda/high_cpu.yaml
```

#### Tesing Keda autoscaling with Chip app based on cron schedule

Adjust the cron schedule in the [manifest](chip-lab/keda/cron_schedule.yaml)

```bash
kubectl apply -f chip-lab/keda/cron_schedule.yaml
```

Monitor the ammount of pods:

```bash
kubectl -n chip get hpa

kubectl -n chip get pods -w
```

Cleanup:

```bash
kubectl delete -f chip-lab/keda/cron_schedule.yaml
```

#### Tesing Keda autoscaling with Chip app based on Prometheus TPS

```bash
kubectl apply -f chip-lab/keda/prometheus_tps.yaml
```

Start requests ( requires [k6](https://k6.io/) )

```bash
k6 run chip-lab/keda/load.js --env MY_CHIP_URL="$CHIP_DOMAIN"
```

Monitor the ammount of pods:

```bash
kubectl -n chip get hpa

kubectl -n chip get pods -w
```

Use also Grafana explorer and the metric `sum(rate(istio_requests_total{destination_service_name="chip"}[1m]))`

Cleanup:

```bash
kubectl delete -f chip-lab/keda/prometheus_tps.yaml
```

#### Cleanup Chip

```bash
kubectl delete -f chip-lab
```

### Health API

```bash
export HEALTH_API_DOMAIN="health.`echo $MY_WILDCARD_DOMAIN | sed 's/*.//'`"
export SQS_QUEUE_URL=`terraform -chdir=terraform/eks-keda output -raw heath_sqs_queue_url`

cat health-api-lab/*.yaml | sed "s/health.yourdomain.com/$HEALTH_API_DOMAIN/" | sed "s;your_sqs_queue_url;$SQS_QUEUE_URL;" | sed "s;your_sqs_queue_url;$SQS_QUEUE_URL;" | kubectl apply -f -

curl -s https://$HEALTH_API_DOMAIN/version
```

#### Tesing Keda autoscaling with Health API 

```bash
cat health-api-lab/keda/metrics_sqs.yaml | sed "s;your_sqs_queue_url;$SQS_QUEUE_URL;" | kubectl apply -f -
```

```bash
while true
do
  curl -s  -X POST \
  -H 'Content-Type: application/json' \
  --data-raw '{ 
    "age": 26,
    "weight": 90.0,
    "height": 1.77,
    "gender": "M", 
    "activity_intensity": "very_active"
  }' https://$HEALTH_API_DOMAIN/calculator
  echo
done
```

Monitor the number of `health-data-offload` pods:

```bash
kubectl -n nutrition get deployments health-data-offload -w
```

Cleanup:

```bash
kubectl delete -f health-api-lab/keda/metrics_sqs.yaml 
```

#### Cleanup Health API

```bash
kubectl delete -f health-api-lab
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
cd terraform/eks-keda
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

Remove log groups from CloudWatch:

```bash
export EKS_NAME=`grep project_name terraform/eks-keda/environment/dev/terraform.tfvars | cut -d"=" -f 2 | sed 's/[" ]//g'`
aws logs describe-log-groups --log-group-name-pattern $EKS_NAME --query 'logGroups[*].logGroupName' --output json | jq -r '.[]' |
while read LOG
do
  aws logs delete-log-group --log-group-name $LOG
done
```

Remove the [day 18](../day18/README.md) EKS networking

See also [karpenter does not delete aws network interface after scale down #5582](https://github.com/aws/karpenter-provider-aws/issues/5582)

## References

[Kubernetes Event-driven Autoscaling](https://keda.sh/)

[K8S Dashboard EN 20250125](https://grafana.com/grafana/dashboards/15661-k8s-dashboard-en-20250125/)

[Chip](https://github.com/msfidelis/chip)

[Why is KEDA API metrics server failing when Istio is installed?](https://keda.sh/troubleshooting/istio-keda-faileddiscoverycheck/)

[KEDA Metrics Server](https://keda.sh/docs/2.16/operate/metrics-server/)

[Set up event-driven auto scaling in Amazon EKS by using Amazon EKS Pod Identity and KEDA](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/event-driven-auto-scaling-with-eks-pod-identity-and-keda.html)

## Tip

Validate the POD indentity about _keda-operator_ and SQS quque:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: aws-cli
  namespace: keda
spec:
  containers:
    - name: aws-cli
      image: amazon/aws-cli
      command: [ "/bin/bash", "-c", "--" ]
      args: [ "while true; do sleep 30; done;" ]
  serviceAccountName: keda-operator
```

Inside the contaier `aws-cli` execute the command

```bash
aws --version
aws sqs get-queue-attributes --queue-url <your sqs queue url> --attribute-names All
```
