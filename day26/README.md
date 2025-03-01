# Linuxtips course: Elastic Kubernetes Service - POD identity, EBS, S3 and EFS CSI addons

## Requirements

* the [day 18](../day18/README.md) EKS networking

## Deploy

Create the files ( we are using [S3-native state locking](https://github.com/hashicorp/terraform/pull/35661) instead of DynamoDB table ):
* `terraform/eks-vanilla/environment/dev/terraform.tfvars`:
  ```tf
  bucket         = "<tfstate bucket name>"
  key            = "<tfstate bucket key>"
  use_lockfile   = true
  region         = "<bucket region>"
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

## POD identity

Check the associatios:

```bash
aws eks list-pod-identity-associations --cluster-name linuxtips-cluster
```

## EBS volume

```bash
kubectl apply -f chip-ebs.yml

kubectl -n chip get pvc                                      
NAME       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
chip-pvc   Bound    pvc-35e996ab-ee57-4e65-8418-26d3e94eff69   1Gi        RWO            gp3            <unset>                 29s
```

### Testing the EBS volume

See [chip endpoints](https://github.com/msfidelis/chip?tab=readme-ov-file#endpoints)

```bash
kubectl -n chip port-forward svc/chip 8080:8080
```

in another terminal:

```bash
curl localhost:8080/version
{"version":"v2"}

curl -X POST localhost:8080/filesystem/ls -i -d '{"path": "/data/"}'

# content is base64 enconded
curl -X POST localhost:8080/filesystem/write -i -d '{"path": "/data/linuxtips", "content": "bGludXh0aXBzIHZhaSAhISEK"}'

curl -X POST localhost:8080/filesystem/cat -i -d '{"path": "/data/linuxtips"}'
```

Cleanup:

```bash
kubectl delete -f chip-ebs.yml
```

Testing the `volumeClaimTemplates`:

```bash
kubectl apply -f chip-statatefulset-ebs.yml

kubectl -n chip get pvc
NAME                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
chip-storage-chip-0   Bound    pvc-08377630-dc5e-4bb8-9375-2fe7fe9e918a   1Gi        RWO            gp3            <unset>                 46s
chip-storage-chip-1   Bound    pvc-0758fb4a-ffa0-49e8-9368-135249cadf8f   1Gi        RWO            gp3            <unset>                 30s
chip-storage-chip-2   Bound    pvc-50c52ed1-be75-49cc-bb0b-7ae8db4d4a7e   1Gi        RWO            gp3            <unset>                 13s
```

Cleanup:

```bash
kubectl delete -f chip-statatefulset-ebs.yml
```

### EFS volume

```bash
EFS_FS_ID=`aws efs describe-file-systems --query 'FileSystems[?Name==\`linuxtips-cluster-efs-shared\`].[FileSystemId]' --output text`
sed "s/<fileSystemId>/$EFS_FS_ID/" chip-efs.yml | kubectl apply -f -
```

Cleanup:

```bash
kubectl delete -f chip-efs.yml
```

### S3 bucket

```bash
S3_BUCKET=`aws s3api list-buckets --query "Buckets[?contains(Name,'chip')].Name" --output text`
sed "s/<bucketName>/$S3_BUCKET/" chip-s3.yml | kubectl apply -f -
```
Cleanup:

```bash
kubectl delete -f chip-s3.yml
```

## Cleanup

```bash
cd terraform/eks-vanilla
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

[Why AWS EKS Pod Identity is a Better Fit Than IRSA for Your Kubernetes Needs](https://medium.com/@prasad.midde3/why-aws-eks-pod-identity-is-a-better-fit-than-irsa-for-your-kubernetes-needs-beba3b8cc1ed)

![Pod Identity vs IRSA](https://miro.medium.com/v2/resize:fit:720/format:webp/1*GkODEp3ZXIS0Cwtg3S9w3g.png)

## TIP

Get [addon version](https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html):

```bash
aws eks describe-addon-versions --addon-name <value>
```
