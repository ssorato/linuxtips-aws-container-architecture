# Linuxtips course: Elastic Kubernetes Service - Others Ingress Controller

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with Nginx Ingress Controller

In this implementation, applications that cannot deal with instability will be managed by Fargate ( namespaces _kube-system_ and _karpenter_ ) ​​and the rest by Karpenter.

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-ingress/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-ingress/environment/dev/terraform.tfvars`:
  * your terraform variables values


Terraform:

```bash
cd terraform/eks-ingress
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

### Nginx Ingress Controller

Be sure that the variable `ingress_nlb` has `ingress_type` set as `nginx`

#### Chip deployment

```bash
kubectl apply -f chip-nginx-ingress.yaml

kubectl get pods -A -l app.kubernetes.io/name=ingress-nginx

kubectl -n ingress-nginx get hpa

kubectl -n ingress-nginx describe TargetGroupBinding | grep -A3 Events
```

Test the NLB:

```bash
export MY_NLB_DNS_NAME=`aws elbv2 describe-load-balancers --names linuxtips-cluster-nlb --query 'LoadBalancers[*].[DNSName]' --output text`

curl  -H 'Host: chip.yourdomain.com' http://$MY_NLB_DNS_NAME/version
{"version":"v2"}

# check pod hostname
curl  -H 'Host: chip.yourdomain.com' http://$MY_NLB_DNS_NAME/system
```

Cleanup:

```bash
kubectl delete -f chip-nginx-ingress.yaml
```

#### Health API deployment

```bash
kubectl apply -f health-api-lab
```

Test the NLB:

```bash
curl  -H 'Host: health.yourdomain.com' http://$MY_NLB_DNS_NAME/version
{"application":"health-api","version":"v1"}

curl -s -H 'Host: health.yourdomain.com' -H 'Content-Type: application/json' \
--data-raw '{ 
   "age": 26,
   "weight": 90.0,
   "height": 1.77,
   "gender": "M", 
   "activity_intensity": "very_active"
}' http://$MY_NLB_DNS_NAME/calculator | jq .
```

Cleanup:

```bash
kubectl delete -f health-api-lab
```

### Traefik Ingress Controller

Be sure that the variable `ingress_nlb` has `ingress_type` set as `traefik`

#### Traefik dashboard 

```bash
kubectl -n traefik port-forward deployments/traefik 8080:8080  
```

open the URL `http://localhost:8080/dashboard`

#### Chip deployment

```bash
kubectl apply -f chip-traefik-ingress.yaml

kubectl get pods -A -l app.kubernetes.io/name=traefik

kubectl -n traefik get hpa

kubectl -n traefik describe TargetGroupBinding | grep -A3 Events
```

Test the NLB:

```bash
export MY_NLB_DNS_NAME=`aws elbv2 describe-load-balancers --names linuxtips-cluster-nlb --query 'LoadBalancers[*].[DNSName]' --output text`

curl  -H 'Host: chip.yourdomain.com' http://$MY_NLB_DNS_NAME/version
{"version":"v2"}

# check pod hostname
curl  -H 'Host: chip.yourdomain.com' http://$MY_NLB_DNS_NAME/system
```

Cleanup:

```bash
kubectl delete -f chip-traefik-ingress.yaml
```

### Cleanup

```bash
cd terraform/eks-ingress
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

Remove log groups from CloudWatch:

```bash
export EKS_NAME=`grep project_name terraform/eks-ingress/environment/dev/terraform.tfvars | cut -d"=" -f 2 | sed 's/[" ]//g'`
aws logs describe-log-groups --log-group-name-pattern $EKS_NAME --query 'logGroups[*].logGroupName' --output json | jq -r '.[]' |
while read LOG
do
  aws logs delete-log-group --log-group-name $LOG
done
```

## References

### Nginx Ingress Controller 

[Ingress-Nginx Controller](https://kubernetes.github.io/ingress-nginx/)

Get default Helm values:
```bash
helm show values ingress-nginx --repo https://kubernetes.github.io/ingress-nginx | less
```

### Traefik

[Traefik](https://doc.traefik.io/traefik/)

Get default Helm values:
```bash
helm show values traefik --repo https://traefik.github.io/charts | less
```
