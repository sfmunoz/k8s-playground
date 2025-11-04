# k3s

- [k3s (plain)](#k3s-plain)
- [k3s (vagrant)](#k3s-vagrant)

## k3s (plain)

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
## k3s (vagrant)

Vagrant refs:

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
$ cd k3s

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
