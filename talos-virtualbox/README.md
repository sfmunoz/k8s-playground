# talos-virtualbox

Talos virtualbox:

- [References](#references)
- [Steps](#steps)

## References

- [Kubernetes home lab on an old computer](https://www.youtube.com/watch?v=VKfE5BuqlSc)
- [VirtualBox: Creating Talos Kubernetes cluster using VirtualBox VMs](https://docs.siderolabs.com/talos/v1.9/platform-specific-installations/local-platforms/virtualbox)

## Steps

Originally based on [Kubernetes home lab on an old computer](https://www.youtube.com/watch?v=VKfE5BuqlSc) but polished from there in a string of iterations:

**(1)** Start VirtualBox VM using using [metal-amd64.iso v1.11.3](https://github.com/siderolabs/talos/releases/download/v1.11.3/metal-amd64.iso) and providing the VM with two network interfaces:

- NAT
- Host-only Adapter, 'vboxnet0'
  - Enabling a DHCP Server the VM will get the IP 192.168.56.3 (Lower Address Bound)

**(2)** Generate the cluster config using the name you want (e.g. **mycluster**) and the IP of the VM (**192.168.56.3**):

```
talosctl gen config mycluster https://192.168.56.3:6443
```

Will create the following files:

- controlplane.yaml
- talosconfig
- worker.yaml

**(3)** Set **TALOSCONFIG** env var to ease upcoming commands (no `--talosconfig` option required):

```
$ export TALOSCONFIG=./talosconfig
```

**(4)** Set endpoints in **./talosconfig** file to ease upcoming command (no `--e/--endpoints` option):
```
$ cp talosconfig talosconfig.old

$ talosctl config endpoint 192.168.56.3

$ diff -U0 talosconfig.old talosconfig
--- talosconfig.old     2025-11-03 19:06:00.499788551 +0000
+++ talosconfig 2025-11-03 19:06:12.838854317 +0000
@@ -4 +4,2 @@
-        endpoints: []
+        endpoints:
+            - 192.168.56.3

$ rm talosconfig.old
```

**(5)** Set nodes in **./talosconfig** file to ease upcoming command (no `--n/--nodes` option):
```
$ cp talosconfig talosconfig.old

$ talosctl config node 192.168.56.3

$ diff -U0 talosconfig.old talosconfig
--- talosconfig.old     2025-11-03 19:08:46.766731253 +0000
+++ talosconfig 2025-11-03 19:08:53.466771547 +0000
@@ -5,0 +6,2 @@
+        nodes:
+            - 192.168.56.3

$ rm talosconfig.old
```

**(6)** Check VM disks (`-n/--nodes` is required here, *failed to determine endpoints* error otherwise):

```
$ talosctl get disks -n 192.168.56.3 --insecure 
NODE   NAMESPACE   TYPE   ID      VERSION   SIZE     ...
       runtime     Disk   loop0   2         73 MB    ---
       runtime     Disk   sda     2         8.6 GB   ...
       runtime     Disk   sr0     2         301 MB   ...
```

**(7)** Tune **controlpanel.yaml → machine → install → disk** to whatever you want

> I'll keep using **/dev/sda** so no changes were made

**(8)** Apply **controlpanel.yaml** configuration (`-n/--nodes` is required here, *failed to determine endpoints* error otherwise):

```
$ talosctl apply-config --nodes 192.168.56.3 --file controlplane.yaml --insecure
```

**(9)** Bootstrap:

```
$ talosctl bootstrap
```

**(10)** Access the dashboard:

```
$ talosctl dashboard
```
**(11)** Check details (etcd, services):

```
$ talosctl logs -f etcd
(... etcd logs ...

$ talosctl services
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

**(12)** Fetch **kubeconfig**:
```
$ talosctl kubeconfig ./kubeconfig
```

**(13)** Use **kubectl** as using with the fetched **kubeconfig**:
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

**(14)** Edit **controlplane.yaml** to set **cluster.allowSchedulingOnControlPlanes: true** to allow workloads to be scheduled on the only running node:
```
$ cp controlplane.yaml controlplane.yaml.old

$ vi controlplane.yaml

$ diff -U0 controlplane.yaml.old controlplane.yaml
--- controlplane.yaml.old       2025-11-03 19:20:50.770692391 +0000
+++ controlplane.yaml   2025-11-03 19:20:54.514452665 +0000
@@ -551 +551 @@
-    # allowSchedulingOnControlPlanes: true
+    allowSchedulingOnControlPlanes: true

$ rm controlplane.yaml.old
```

**(15)** Apply the new configuration:

```
$ talosctl apply-config --file controlplane.yaml
Applied configuration without a reboot
```
