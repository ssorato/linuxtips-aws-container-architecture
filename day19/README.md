# Linuxtips course: Elastic Kubernetes Service - Vanilla cluster minimal setup

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy

```bash
Create the files:
* `terraform/eks-vanilla/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  dynamodb_table = "<tfstate lock dynamodb table name>"
  region         = "<bucket and dynamodb region>"
  ```
* `terraform/eks-vanilla/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-vanilla
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

### EKS access entries

```bash
aws eks list-access-policies --output table

aws eks list-access-entries --cluster-name linuxtips-cluster

aws eks describe-access-entry --cluster-name linuxtips-cluster --principal-arn <arn>

aws eks list-associated-access-policies --cluster-name linuxtips-cluster --principal <arn>
```

## First deployment

```bash
kubectl apply -f chip.yaml
kubectl -n chip get all
```

## Cleanup

```bash
cd terraform/eks-vanilla
terraform destroy -var-file=environment/dev/terraform.tfvars
rm -r .terraform.lock.hcl 
rm -rf .terraform
cd ../..
```

## References

[Grant IAM users access to Kubernetes with EKS access entries](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html)

[AWS EKS – Part 20 – Authentication and Authorization with Access Entries](https://kubedemy.io/aws-eks-part-20-authentication-and-authorization-with-access-entries)

