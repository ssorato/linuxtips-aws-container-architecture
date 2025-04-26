# Linuxtips course: Elastic Kubernetes Service - Helm Charts

## Requirements

* the [day 18](../day18/README.md) EKS networking
* the [day 32](../day32/README.md) EKS with Argo Rollouts (without deploying _Chip_ application)

## Helmify

```bash
cd day33/helm

# Create a sample helm
helm create temp/linuxtips-helm-create

# Convert chip-rollout into a Helm
cat ../chip-rollouts.yml | helmify temp/linuxtips-helmify
```

## Kubeconfig

```bash
aws eks update-kubeconfig --region us-east-1 --name linuxtips-cluster --kubeconfig ~/.kube/linuxtips-cluster --alias linuxtips-cluster
export KUBECONFIG=~/.kube/linuxtips-cluster
```

## Helm app

Install the Helm app

```bash
export CHIP_DOMAIN=<your chip domain>

# preview
helm upgrade linuxtips linuxtips/ --install --set app.istio.host=$CHIP_DOMAIN --dry-run
helm template --debug linuxtips --set app.istio.host=$CHIP_DOMAIN

# upgrade or install
helm upgrade linuxtips linuxtips/ --install --set app.istio.host=$CHIP_DOMAIN

# namespace scope is default
helm list
helm get values linuxtips

kubectl -n linuxtips get rollouts
kubectl -n linuxtips get all
kubectl -n linuxtips get scaledobject 
```

Create the Helm package:

```bash
helm package linuxtips --destination temp/
```

Cleanup:

```bash
helm uninstall linuxtips
```

## References

[Helmify](https://github.com/arttor/helmify)
