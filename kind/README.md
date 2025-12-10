# kind

- [References](#references)
- [Install](#install)
- [Basic usage](#basic-usage)

## References

- [https://kind.sigs.k8s.io/docs/user/quick-start/](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [https://github.com/kubernetes-sigs/kind/](https://github.com/kubernetes-sigs/kind/)

## Install

Ref: https://kind.sigs.k8s.io/docs/user/quick-start/

I'm using **brew**:
```
$ brew install kind
```
Alternative:
```
$ curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64

$ sudo install -o root -g root -m 0755 kind /usr/local/bin/kind

$ kind version
kind v0.30.0 go1.24.6 linux/amd64
```
zsh autocompletion:
```
$ source <(kind completion zsh)
```
## Basic usage
```
$ kind create cluster --name c1 --wait 5m
(...)

$ kind get clusters 
c1

$ kubectl config get-clusters
NAME
kind-c1

$ kubectl cluster-info --context kind-c1
Kubernetes control plane is running at https://127.0.0.1:35045
CoreDNS is running at https://127.0.0.1:35045/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         kind-c1   kind-c1   kind-c1

$ kind delete cluster --name c1
(...)
```
Ad hoc config export (e.g. combine it with k3s config in the same file):
```
$ scp root@65.20.104.59:/etc/rancher/k3s/k3s.yaml ~/.kube/config

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         default   default   default

$ kind export kubeconfig -n c1
Set kubectl context to "kind-c1"

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
          default   default   default
*         kind-c1   kind-c1   kind-c1
```
