# AWS mountpoint

- [1. s3-cfg](#1-s3-cfg)
- [2. aws-mountpoint-s3-csi-driver](#2-aws-mountpoint-s3-csi-driver)
- [3. s3](#3-s3)

Step by step from a clean slate

## 1. s3-cfg
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
