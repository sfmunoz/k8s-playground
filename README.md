# k8s-playground

Kubernetes playground

- [References](#references)
- [Usage](#usage)
  - [1. s3-cfg](#1-s3-cfg)
  - [2. aws-mountpoint-s3-csi-driver](#2-aws-mountpoint-s3-csi-driver)
  - [3. s3](#3-s3)
- [kubectl](#kubectl)
- [k3s](#k3s)
- [Vagrant](#vagrant)
- [Vultr](#vultr)
- [kind](#kind)

## References

- https://kubernetes.io/
- https://k3s.io/
- https://kind.sigs.k8s.io/
- https://www.vultr.com/

## Usage

Step by step from a clean slate:

### 1. s3-cfg
```
$ cat s3-cfg/Chart.yaml
(...)
# Required:
#
#   - https://github.com/FiloSottile/age
#     # apt install age
#   - https://github.com/getsops/sops
#     $ curl -LO https://github.com/getsops/sops/releases/download/v3.10.2/sops-v3.10.2.linux.amd64
#   - https://github.com/jkroepke/helm-secrets
#     $ helm plugin install https://github.com/jkroepke/helm-secrets
#
# Install/upgrade:
#
#   $ helm upgrade --install -n dev --create-namespace -f secrets://secrets.yaml s3-cfg .
(...)
```
## 2. aws-mountpoint-s3-csi-driver
```
$ cat aws-mountpoint-s3-csi-driver/install.sh
#!/bin/bash
(...)
helm repo add aws-mountpoint-s3-csi-driver https://awslabs.github.io/mountpoint-s3-csi-driver
helm repo update
(...)
helm upgrade \
  --install aws-mountpoint-s3-csi-driver \
  --namespace kube-system \
  aws-mountpoint-s3-csi-driver/aws-mountpoint-s3-csi-driver
(...)
```
## 3. s3
```
$ cat s3/Chart.yaml 
(...)
# Install/upgrade:
#
#   $ helm upgrade --install -n dev --create-namespace -f secrets://secrets.yaml s3 .
(...)
```

## kubectl

Google: 'kubectl install' → https://kubernetes.io/docs/tasks/tools/ → https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

```
$ curl -L -s https://dl.k8s.io/release/stable.txt
v1.34.1

$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

$ echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
kubectl: OK

$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

$ kubectl version --client
Client Version: v1.34.1
Kustomize Version: v5.7.1

$ kubectl version --client --output=yaml
clientVersion:
  buildDate: "2025-09-09T19:44:50Z"
  compiler: gc
  gitCommit: 93248f9ae092f571eb870b7664c534bfc7d00f03
  gitTreeState: clean
  gitVersion: v1.34.1
  goVersion: go1.24.6
  major: "1"
  minor: "34"
  platform: linux/amd64
kustomizeVersion: v5.7.1
```

zsh autocompletion:

```
$ source <(kubectl completion zsh)
```

## k3s

Ref: https://k3s.io/

Install:

```
$ curl -sfL https://get.k3s.io | bash -
```

Config:

- Copy **/etc/rancher/k3s/k3s.yaml** to **~/.kube/config**
- Tune **clusters → cluster → server**
  - From `https://127.0.0.1:6443`
  - To `https://[ip_addr]:6443`

Uninstall:

```
# systemctl stop k3s
# k3s-uninstall.sh
```

## Vagrant

Refs:

- https://developer.hashicorp.com/vagrant/docs/boxes
- https://vagrantcloud.com/boxes/search
- **[https://vagrantcloud.com/bento](https://vagrantcloud.com/bento)** → recommended at https://developer.hashicorp.com/vagrant/docs/boxes
- https://developer.hashicorp.com/vagrant/docs/vagrantfile

Environment:

- Linux Mint 22.2 (the one used, other Linux distributions may be OK)
- Vagrant 2.4.9
- VirtualBox 7.2

Usage from the root of this repository clone (provided with [Vagrantfile](https://github.com/sfmunoz/k8s-playground/blob/main/Vagrantfile)):

```
$ vagrant up

$ vagrant ssh -c 'sudo -u root cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config

$ kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:6443
CoreDNS is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/https:metrics-server:https/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

$ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.43.0.1    <none>        443/TCP   2m4s

$ vagrant halt    (alt: "vagrant destroy" to do away with everything)
```

## Vultr

Instance creation with **Debian 13** and **k3s** installed (plan/region/OS/script/ssh-key details follow):
```
$ vultr-cli instance create -r mad -p vc2-1c-2gb --os 2625 --script-id 402931bb-6d73-4b19-9b71-857da8951f0d -s dea4ebd6-c439-497f-a145-761cfa9ce68b
```
ssh shortcut to use **kubectl** from the local computer (it can be used from within the instance too):
```
$ vultr-cli instance list
ID                                      IP              LABEL   OS                      STATUS  REGION  CPU     RAM     DISK    BANDWIDTH       TAGS
(...)
0768fad1-a988-4362-9357-0554659bd854    208.76.222.72           Debian 13 x64 (trixie)  active  mad     1       2048    55      3               []
(...)

$ scp root@208.76.222.72:/etc/rancher/k3s/k3s.yaml ~/.kube/config

$ ssh -L 6443:127.0.0.1:6443 root@208.76.222.72
```
Plan:
```
$ vultr-cli plans list
ID                              VCPU COUNT      RAM     DISK    DISK COUNT      BANDWIDTH GB    PRICE PER MONTH         TYPE    GPU VRAM        GPU TYPE        REGIONS
(...)
vc2-1c-2gb                      1               2048    55      1               2048            10.00                   vc2     0                               [ewr, ord, dfw, sea, lax, atl, ams, lhr, fra, sjc, syd, yto, cdg, nrt, waw, mad, icn, mia, sgp, sto, mex, mel, bom, jnb, tlv, blr, del, scl, itm, man]
(...)
```
Region:
```
$ vultr-cli regions list
ID      CITY            COUNTRY         CONTINENT       OPTIONS
(...)
mad     Madrid          ES              Europe          [ddos_protection, block_storage_storage_opt, load_balancers, kubernetes]
(...)
```
OS:
```
$ vultr-cli os list
ID      NAME                                    ARCH    FAMILY
(...)
2625    Debian 13 x64 (trixie)                  x64     debian
(...)
```
Script:
```
$ vultr-cli script list
ID                                      DATE CREATED                    DATE MODIFIED                   TYPE    NAME
(...)
402931bb-6d73-4b19-9b71-857da8951f0d    2025-09-19T08:03:30+00:00       2025-09-19T08:15:53+00:00       boot    k3s
(...)
```
ssh-key:
```
$ vultr-cli ssh-key list
ID                                      DATE CREATED                    NAME    KEY
(...)
dea4ebd6-c439-497f-a145-761cfa9ce68b    2025-..-..T..:..:..+..:..       sfm     ssh-rsa AAAA...g3uDkQ== sfm
```

## kind

Ref: https://kind.sigs.k8s.io/docs/user/quick-start/

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

Basic usage:

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
