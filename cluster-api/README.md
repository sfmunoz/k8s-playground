# cluster-api

- [References](#references)
- [Vanilla example](#vanilla-example)

## References

- [https://cluster-api.sigs.k8s.io/](https://cluster-api.sigs.k8s.io/)
- [https://github.com/kubernetes-sigs/cluster-api](https://github.com/kubernetes-sigs/cluster-api)

Extra refs:

- https://github.com/k3s-io/cluster-api-k3s
  - Cluster API Bootstrap Provider k3s (CABP3)
  - Cluster API ControlPlane Provider k3s (CACP3)
- https://github.com/vultr/cluster-api-provider-vultr
  - CAPVULTR v1beta1 (v0.1.0)
  - https://github.com/vultr/cluster-api-provider-vultr/blob/main/docs/getting-started.md

## Vanilla example

kind cluster creation:
```
$ kind create cluster --name dev --wait 5m
Creating cluster "dev" ...
 ✓ Ensuring node image (kindest/node:v1.34.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Waiting ≤ 5m0s for control-plane = Ready ⏳
 • Ready after 17s 💚
Set kubectl context to "kind-dev"
You can now use your cluster with:

kubectl cluster-info --context kind-dev

Have a nice day! 👋

$ kubectl get nodes
NAME                STATUS   ROLES           AGE     VERSION
dev-control-plane   Ready    control-plane   2m17s   v1.34.0
```
clusterctl init:
```
$ clusterctl init
Fetching providers
Installing cert-manager version="v1.19.1"
(... some unrecognized format "int32/int64" messages ...)
Waiting for cert-manager to be available...
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
Installing provider="cluster-api" version="v1.12.0" targetNamespace="capi-system"
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
(... some unrecognized format "int32/int64" messages ...)
Installing provider="bootstrap-kubeadm" version="v1.12.0" targetNamespace="capi-kubeadm-bootstrap-system"
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
(... some unrecognized format "int32/int64" messages ...)
Installing provider="control-plane-kubeadm" version="v1.12.0" targetNamespace="capi-kubeadm-control-plane-system"
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
(... some unrecognized format "int32/int64" messages ...)

Your management cluster has been initialized successfully!

You can now create your first workload cluster by running the following:

  clusterctl generate cluster [name] --kubernetes-version [version] | kubectl apply -f -
```
