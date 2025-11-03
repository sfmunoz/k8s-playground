# talos-virtualbox

Talos virtualbox:

- [References](#references)
- [Steps](#steps)

## References

- [Kubernetes home lab on an old computer](https://www.youtube.com/watch?v=VKfE5BuqlSc)
- [VirtualBox: Creating Talos Kubernetes cluster using VirtualBox VMs](https://docs.siderolabs.com/talos/v1.9/platform-specific-installations/local-platforms/virtualbox)

## Steps

**(1)** Start VirtualBox VM using using [metal-amd64.iso v1.11.3](https://github.com/siderolabs/talos/releases/download/v1.11.3/metal-amd64.iso) and provinding the VM with two network interfaces:

- NAT
- Host-only Adapter, 'vboxnet0'
  - Enabling a DHCP Server the VM will get the IP 192.168.56.3 (Lower Address Bound)

**(2)** Generate the cluster config:

```
talosctl gen config mycluster https://192.168.56.3:6443
```

Will create the following files:

- controlplane.yaml
- talosconfig
- worker.yaml

**(3)** Check VM disks:

```
$ talosctl get disks --nodes 192.168.56.3 --insecure 
NODE   NAMESPACE   TYPE   ID      VERSION   SIZE     ...
       runtime     Disk   loop0   2         73 MB    ---
       runtime     Disk   sda     2         8.6 GB   ...
       runtime     Disk   sr0     2         301 MB   ...
```

**(4)** Tune **controlpanel.yaml → machine → install → disk** to whatever you want (I'll keep using **/dev/sda**).

**(5)** Apply **controlpanel.yaml** configuration:

```
$ talosctl apply-config --nodes 192.168.56.3 --file controlplane.yaml --insecure
```

**(6)** Bootstrap:

```
$ talosctl bootstrap -n 192.168.56.3 -e 192.168.56.3 --talosconfig ./talosconfig
```

**(7)** Access the dashboard:

```
$ talosctl dashboard -n 192.168.56.3 -e 192.168.56.3 --talosconfig ./talosconfig
```
**(8)** Check details (etcd, services):

```
$ talosctl logs -f -n 192.168.56.3 -e 192.168.56.3 --talosconfig ./talosconfig etcd
(... etcd logs ...

$ talosctl services -n 192.168.56.3 -e 192.168.56.3 --talosconfig ./talosconfig
NODE           SERVICE      STATE     HEALTH   LAST CHANGE   LAST EVENT
192.168.56.3   apid         Running   OK       5m51s ago     Health check successful
192.168.56.3   auditd       Running   OK       5m56s ago     Health check successful
192.168.56.3   containerd   Running   OK       5m56s ago     Health check successful
192.168.56.3   cri          Running   OK       5m51s ago     Health check successful
192.168.56.3   dashboard    Running   ?        5m54s ago     Process Process(["/sbin/dashboard"]) started with PID 2000
192.168.56.3   etcd         Running   OK       3m49s ago     Health check successful
192.168.56.3   kubelet      Running   OK       5m43s ago     Health check successful
192.168.56.3   machined     Running   OK       5m56s ago     Health check successful
192.168.56.3   syslogd      Running   OK       5m55s ago     Health check successful
192.168.56.3   trustd       Running   OK       5m50s ago     Health check successful
192.168.56.3   udevd        Running   OK       5m55s ago     Health check successful
```

**(9)** Fetch **kubeconfig**:
```
$ talosctl -n 192.168.56.3 -e 192.168.56.3 --talosconfig ./talosconfig kubeconfig ./kubeconfig
```

**(10)** Use **kubectl** as using with the fetched **kubeconfig**:
```
$ export KUBECONFIG=./kubeconfig

$ kubectl get nodes
NAME            STATUS   ROLES           AGE     VERSION
talos-hr8-nu6   Ready    control-plane   4m35s   v1.34.1

$ kubectl get pods -A
NAMESPACE     NAME                                    READY   STATUS    RESTARTS        AGE
kube-system   coredns-5c6c88fddd-t5w2l                1/1     Running   0               4m54s
kube-system   coredns-5c6c88fddd-vfnbs                1/1     Running   0               4m54s
kube-system   kube-apiserver-talos-hr8-nu6            1/1     Running   0               4m18s
kube-system   kube-controller-manager-talos-hr8-nu6   1/1     Running   2 (5m20s ago)   4m18s
kube-system   kube-flannel-9krgb                      1/1     Running   0               4m36s
kube-system   kube-proxy-f5b94                        1/1     Running   0               4m36s
kube-system   kube-scheduler-talos-hr8-nu6            1/1     Running   3 (5m9s ago)    4m18s
```

**(11)** Edit **controlplane.yaml** to set **cluster.allowSchedulingOnControlPlanes: true**

This allows workload to be scheduled on the only running node

**(12)** Apply the new configuration:

```
$ talosctl apply-config --nodes 192.168.56.3 -e 192.168.56.3 --talosconfig ./talosconfig --file controlplane.yaml
Applied configuration without a reboot
```
