# k8s-playground

Kubernetes playground

- [References](#references)
- [kubectl](#kubectl)
- [k3s](k3s/README.md)
- [talos-docker](talos-docker/README.md)
- [talos-virtualbox](talos-virtualbox/README.md)
- [AWS mountpoint](#aws-mountpoint)
  - [1. s3-cfg](#1-s3-cfg)
  - [2. aws-mountpoint-s3-csi-driver](#2-aws-mountpoint-s3-csi-driver)
  - [3. s3](#3-s3)
- [Vultr](docs/vultr.md)
- [kind](docs/kind.md)

## References

- https://kubernetes.io/
- https://helm.sh/

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

## AWS mountpoint

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
