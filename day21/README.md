# Linuxtips course: Elastic Kubernetes Service - Cluster full Fargate

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy EKS with EC2 and Fargate

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-ec2-fargate/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-ec2-fargate/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-ec2-fargate
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

Notice: on fargate an EKS node per POD is created

```bash
kubectl apply -f chip.yaml
```

### Cleanup EKS with EC2 and Fargate

```bash
cd terraform/eks-ec2-fargate
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```


## Deploy EKS full Fargate

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-full-fargate/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-full-fargate/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-full-fargate
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

Notice: on fargate an EKS node per POD is created

```bash
kubectl apply -f chip_fargate.yaml
```

Billing is based on node annotation _CapacityProvisioned_

```bash
kubectl -n chip get pod chip-7458c7c4d9-ck2cq -o jsonpath="{.metadata.annotations.CapacityProvisioned}"
2vCPU 4GB
```

### Cleanup EKS full Fargate

```bash
cd terraform/eks-full-fargate
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

### References

[Troubleshoot Amazon ECS task definition invalid CPU or memory errors](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)

[Get started with AWS Fargate for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html)
