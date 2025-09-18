# k8s-playground

Kubernetes playground

- [References](#references)
- [kubectl](#kubectl)
- [k3s](#k3s)

## References

- https://kubernetes.io/
- https://k3s.io/

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
