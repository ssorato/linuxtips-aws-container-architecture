# Linuxtips course: Elastic Kubernetes Service - Automode

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-automode/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-automode/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-automode
terraform init -backend-config=environment/dev/backend.tfvars
terraform validate
terraform plan -var-file=environment/dev/terraform.tfvars
terraform apply -var-file=environment/dev/terraform.tfvars
cd ../..
```

## Kubeconfig

```bash
aws eks update-kubeconfig --region us-east-1 --name linuxtips-cluster --kubeconfig ~/.kube/linuxtips-cluster --alias linuxtips-cluster

export KUBECONFIG=~/.kube/linuxtips-cluster
kubectl cluster-info 
kubectl get nodes
```

## EKS Automode

```bash
kubectl get all -A
NAMESPACE     NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
default       service/kubernetes                  ClusterIP   172.20.0.1       <none>        443/TCP   7m30s
kube-system   service/eks-extension-metrics-api   ClusterIP   172.20.119.175   <none>        443/TCP   7m28s

kubectl get nodepools              
NAME              NODECLASS   NODES   READY   AGE
general-purpose   default     0       True    9m26s
system            default     0       True    9m26s
```

### Deploy chip application

Using `general-purpose` nodepool:

```bash
kubectl apply -f chip.yaml

kubectl delete -f chip.yaml
```

Using `system` nodepool:

```bash
kubectl apply -f chip-system.yaml

kubectl delete -f chip-system.yaml
```

Testing Ingress Controller:

```bash
kubectl apply -f ingress-class.yaml
kubectl apply -f chip-ingress.yaml

kubectl delete -f ingress-class.yaml
kubectl delete -f chip-ingress.yaml
```

## Cleanup

```bash
cd terraform/eks-automode
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

[Automate cluster infrastructure with EKS Auto Mode](https://docs.aws.amazon.com/eks/latest/userguide/automode.html)

[Terraform EKS Cluster with EKS Auto Mode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#eks-cluster-with-eks-auto-mode)

