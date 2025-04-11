# Linuxtips course: Elastic Kubernetes Service - Istio Service Mesh

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with Nginx Ingress Controller

In this implementation, applications that cannot deal with instability will be managed by Fargate ( namespaces _kube-system_ and _karpenter_ ) ​​and the rest by Karpenter.

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-istio/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-istio/environment/dev/terraform.tfvars`:

Terraform:

```bash
cd terraform/eks-istio
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

### Healt API

```bash
export HEALTH_API_DOMAIN="health.`echo $MY_WILDCARD_DOMAIN | sed 's/*.//'`"
kubectl apply -f health-api-lab
cat health-api-lab/01_health-api.yaml | sed "s/health.yourdomain.com/$HEALTH_API_DOMAIN/" | kubectl apply -f -

curl -s https://$HEALTH_API_DOMAIN/version


curl -s  -X POST \
-H 'Content-Type: application/json' \
--data-raw '{ 
   "age": 26,
   "weight": 90.0,
   "height": 1.77,
   "gender": "M", 
   "activity_intensity": "very_active"
}' https://$HEALTH_API_DOMAIN/calculator | jq .
```

### Chip

```bash
export CHIP_DOMAIN="chip.`echo $MY_WILDCARD_DOMAIN | sed 's/*.//'`"
cat chip-lab/01_chip.yml| sed "s/chip.yourdomain.com/$CHIP_DOMAIN/" | kubectl apply -f -

curl -s https://$CHIP_DOMAIN/version

# Fault injection
curl -s https://$CHIP_DOMAIN/healthcheck/fault


# Proxy Request - Used to test Istio Service Entry
curl --location --request POST https://$CHIP_DOMAIN/proxy \
--header 'Content-Type: application/json' \
--data-raw '{
    "method": "GET",
    "host": "https://google.com.br/",
    "path": "/",
    "headers": [
        {
            "name": "content-type",
            "value": "application/json"
        },
        {
            "name": "foo",
            "value": "bar"
        }
    ],
    "body": "{\"vai\": \"sim\"}"
}' 
```

See also [Chip](https://github.com/msfidelis/chip)

#### Prometheus web UI

```bash
kubectl -n prometheus port-forward svc/prometheus-operated 9090:9090
```

and open the URL _http://localhost:9090_

#### Grafana

Loggin into URL _https://grafanalab.yourdomain.com_

#### Jaeger

Loggin into URL _https://jaegeerlab.yourdomain.com_

#### Kiali

Loggin into URL _https://kialilab.yourdomain.com_

#### Cleanup Healt API and Chip

```bash
kubectl delete -f health-api-lab
kubectl delete -f chip-lab
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
cd terraform/eks-istio
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

Remove log groups from CloudWatch:

```bash
export EKS_NAME=`grep project_name terraform/eks-istio/environment/dev/terraform.tfvars | cut -d"=" -f 2 | sed 's/[" ]//g'`
aws logs describe-log-groups --log-group-name-pattern $EKS_NAME --query 'logGroups[*].logGroupName' --output json | jq -r '.[]' |
while read LOG
do
  aws logs delete-log-group --log-group-name $LOG
done
```

Remove the [day 18](../day18/README.md) EKS networking

## References

[Istio](https://istio.io/latest/docs/overview/what-is-istio/)

[Istio Grafana Dashboards](https://istio.io/latest/docs/ops/integrations/grafana/)

[Istio Service Entry](https://istio.io/latest/docs/reference/config/networking/service-entry/)

>>> `ServiceEntry` enables adding additional entries into Istio’s internal service registry, so that auto-discovered services in the mesh can access/route to these manually specified services