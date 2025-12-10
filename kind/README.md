# kind

- [References](#references)
- [Install](#install)
- [Basic usage](#basic-usage)
- [Docker containers](#docker-containers)

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
## Docker containers
Using **dev.yaml**:
```
kind create cluster --name dev --config dev.yaml --wait 5m
```
Result:
```
$ kubectl get nodes
NAME                STATUS   ROLES           AGE     VERSION
dev-control-plane   Ready    control-plane   5m12s   v1.34.0
dev-worker          Ready    <none>          5m      v1.34.0
dev-worker2         Ready    <none>          5m      v1.34.0
dev-worker3         Ready    <none>          5m      v1.34.0

$ docker ps -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                       NAMES
25b47edcedfe   kindest/node:v1.34.0   "/usr/local/bin/entr…"   5 minutes ago   Up 5 minutes   127.0.0.1:33499->6443/tcp   dev-control-plane
c39defc79d9b   kindest/node:v1.34.0   "/usr/local/bin/entr…"   5 minutes ago   Up 5 minutes                               dev-worker2
9dfa6a159cbc   kindest/node:v1.34.0   "/usr/local/bin/entr…"   5 minutes ago   Up 5 minutes                               dev-worker
04592f9dcde9   kindest/node:v1.34.0   "/usr/local/bin/entr…"   5 minutes ago   Up 5 minutes                               dev-worker3
```
Enter control panel (same for workers):
```
$ docker exec -it dev-control-plane bash

root@dev-control-plane:/# crictl pods
POD ID              CREATED             STATE               NAME                                        NAMESPACE            ATTEMPT             RUNTIME
6ba7da1eca2a5       5 minutes ago       Ready               coredns-66bc5c9577-5rt6v                    kube-system          0                   (default)
d6e983357d443       5 minutes ago       Ready               coredns-66bc5c9577-8tm9r                    kube-system          0                   (default)
07a18a502af93       5 minutes ago       Ready               local-path-provisioner-7b8c8ddbd6-86cwv     local-path-storage   0                   (default)
1ac65fa93ec2f       6 minutes ago       Ready               kube-proxy-xqxx6                            kube-system          0                   (default)
79cdb6c1603d4       6 minutes ago       Ready               kindnet-h8f4l                               kube-system          0                   (default)
f994059786fb8       6 minutes ago       Ready               kube-scheduler-dev-control-plane            kube-system          0                   (default)
d6c91a3a3f07a       6 minutes ago       Ready               kube-controller-manager-dev-control-plane   kube-system          0                   (default)
66df3cd437dee       6 minutes ago       Ready               kube-apiserver-dev-control-plane            kube-system          0                   (default)
ca0199f7e5cfa       6 minutes ago       Ready               etcd-dev-control-plane                      kube-system          0                   (default)
```
