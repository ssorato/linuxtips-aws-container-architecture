# Linuxtips course: Elastic Kubernetes Service - Cluster full Fargate

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with Karpenter

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-karpenter/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-karpenter/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-karpenter
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

### Chip deploy

```bash
kubectl apply -f chip.yaml

kubectl get nodeclaims
```

### Cleanup

```bash
cd terraform/eks-karpenter
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

### References

[Karpenter](https://karpenter.sh)

[Karpenter — Estratégias para resiliência no uso de Spot Instances em produção](https://fidelissauro.dev/karpenter-estrategias-para-resiliencia-no-uso-de-spot-instances-em-producao/)

[Karpenter Topology Spread](https://karpenter.sh/docs/concepts/scheduling/#topology-spread)

[Karpenter spec.amiFamily](https://karpenter.sh/docs/concepts/nodeclasses/#specamifamily)

[Retrieve recommended Amazon Linux AMI IDs](https://docs.aws.amazon.com/eks/latest/userguide/retrieve-ami-id.html)

[Retrieve recommended Bottlerocket AMI IDs](https://docs.aws.amazon.com/eks/latest/userguide/retrieve-ami-id-bottlerocket.html)
