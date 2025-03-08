# Linuxtips course: Elastic Kubernetes Service - External Secrets with AWS Secrets Manager

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-ext-secrets/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
  ```
* `terraform/eks-ext-secrets/environment/dev/terraform.tfvars`:
  * your terraform variables values

Terraform:

```bash
cd terraform/eks-ext-secrets
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

## POD identity

Check the associatios:

```bash
aws eks list-pod-identity-associations --cluster-name linuxtips-cluster
```

## External Secrets

### Bastion POD

Used to tests Chip endpoint.

Start a bastion pod:

```bash
kubectl -n default run bastionpod --rm -it --image debian -- bash
```

Install `curl` and `jq`

```bash
apt-get update && apt install -y  curl jq
```

### Get secret value

```bash
kubectl apply -f chip-external-secrets.yaml

kubectl -n chip get externalsecrets.external-secrets.io
```

Get the content of the secret:

```bash
kubectl -n chip get secrets chip-aws-secret -o jsonpath="{.data.FOO}" | base64 -d && echo
```

Inside the _bastion POD_ get the content of the Chip environment variable:

```bash
curl -s chip.chip:8080/system/environment | jq -r '.[] | select(test("^FOO"))'
```

Cleanup:

```bash
kubectl delete -f chip-external-secrets.yaml
```

### Get JSON secret value

```bash
kubectl apply -f chip-json.yaml

kubectl -n chip get externalsecrets.external-secrets.io
```

Get the content of the secret:

```bash
kubectl -n chip get secrets chip-aws-secret-json -o jsonpath="{.data.USER}" | base64 -d && echo

kubectl -n chip get secrets chip-aws-secret-json -o jsonpath="{.data.PASS}" | base64 -d && echo 
```

Inside the _bastion POD_ get the content of the Chip environment variable:

```bash
curl -s chip.chip:8080/system/environment | jq -r '.[] | select(test("^USERNAME"))'

curl -s chip.chip:8080/system/environment | jq -r '.[] | select(test("^PASSWORD"))'
```

Cleanup:

```bash
kubectl delete -f chip-json.yaml
```

### Get Parameter Store value

```bash
kubectl apply -f chip-ssm.yaml

kubectl -n chip get externalsecrets.external-secrets.io
```

Get the content of the secret:

```bash
kubectl -n chip get secrets chip-aws-parameters -o jsonpath="{.data.PARAMETRO_EXEMPLO}" | base64 -d && echo
```

Inside the _bastion POD_ get the content of the Chip environment variable:

```bash
curl -s chip.chip:8080/system/environment | jq -r '.[] | select(test("^PARAMETRO_EXEMPLO"))'
```

Cleanup:

```bash
kubectl delete -f chip-ssm.yaml
```

## Cleanup

Exit from the _bastion POD_ 

```bash
oot@bastionpod:/# exit
```

and destroy the infra: 

```bash
cd terraform/eks-ext-secrets
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

[Chip](https://github.com/msfidelis/chip)

[AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)

[External Secrets Operator - AWS Secrets Manager](https://external-secrets.io/latest/provider/aws-secrets-manager/)

![AWS Secrets Manager](https://external-secrets.io/latest/pictures/eso-az-kv-aws-sm.png)

