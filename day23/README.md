# Linuxtips course: Elastic Kubernetes Service - Karpenter groupless and Fargate profile

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with Karpenter

In this implementation, applications that cannot deal with instability will be managed by Fargate ( namespaces _kube-system_ and _karpenter_ ) ​​and the rest by Karpenter.

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-karpenter-groupless/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-karpenter-groupless/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-karpenter-groupless
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

### Metric server on Fargate

Get metrics:

```bash
kubectl -n kube-system get deployments/metrics-server

kubectl top pod -A

kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes | jq '.items[].metadata.name'
kubectl get --raw /apis/metrics.k8s.io/v1beta1/pods | jq '.items[].metadata.name'
```

> [!CAUTION]
> Canot get metrics from `metric-server` fargate node. Still needs to be investigated.

```bash
scraper.go:149] "Failed to scrape node" err="Get \"https://100.64.153.4:10250/metrics/resource\": dial tcp 100.64.153.4:10250: connect: connection refused" node="fargate-ip-100-64-153-4.ec2.internal"
```

### Chip deploy

```bash
kubectl apply -f chip.yaml

kubectl get nodeclaims
```

### health-api lab

>>> Using the health-api lab, segregate specific NodePools for each type of microservice and change the manifests to use this segregation appropriately.

```bash
kubectl apply -f health-api-lab 
```

### Testing the application

```bash
kubectl -n health-api port-forward svc/health-api 8080:8080
```

in another terminal:

```bash
curl localhost:8080/version                                                                           
{"application":"health-api","version":"v1"}

curl -s -H 'Content-Type: application/json' \
--data-raw '{ 
   "age": 26,
   "weight": 90.0,
   "height": 1.77,
   "gender": "M", 
   "activity_intensity": "very_active"
}' localhost:8080/calculator | jq .
{
  "id": "45fb16f9-578a-445a-9f87-b4ed8cc7917b",
  "status": 200,
  "imc": {
    "result": 28.72737719046251,
    "class": "overweight"
  },
  "basal": {
    "bmr": {
      "value": 2188.5,
      "unit": "kcal"
    },
    "necessity": {
      "value": 3775.1625000000004,
      "unit": "kcal"
    }
  },
  "health_info": {
    "age": 26,
    "weight": 90,
    "height": 1.77,
    "gender": "M",
    "activity_intensity": "very_active"
  },
  "recomendations": {
    "protein": {
      "value": 180,
      "unit": "kcal"
    },
    "water": {
      "value": 3150,
      "unit": "ml"
    },
    "calories": {
      "maintain_weight": {
        "value": 3775.1625000000004,
        "unit": "kcal"
      },
      "loss_weight": {
        "value": 3397.6462500000002,
        "unit": "kcal"
      },
      "gain_weight": {
        "value": 4907.71125,
        "unit": "kcal"
      }
    }
  }
}
```

### Cleanup

```bash
cd terraform/eks-karpenter-groupless
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

Remove log groups from CloudWatch:

```bash
export EKS_NAME=`grep project_name terraform/eks-karpenter-groupless/environment/dev/terraform.tfvars | cut -d"=" -f 2 | sed 's/[" ]//g'`
aws logs describe-log-groups --log-group-name-pattern $EKS_NAME --query 'logGroups[*].logGroupName' --output json | jq -r '.[]' |
while read LOG
do
  aws logs delete-log-group --log-group-name $LOG
done
```

## References

[Karpenter](https://karpenter.sh)

[terraform-aws-modules/terraform-aws-eks/examples/fargate_profile/main.tf](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/273c48a631c0ab45ffac1d1a77c7752e8541b1f2/examples/fargate_profile/main.tf#L36-L40)

[CoreDNS Configuration Options](https://aws-quickstart.github.io/cdk-eks-blueprints/addons/coredns/#configuration-options)

>>> Note: To deploy fargate cluster, we need to pass `configurationValue.computeType` as "Fargate" as described in the EKS Fargate documentation

