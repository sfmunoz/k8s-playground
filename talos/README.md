# talos

## References

- [Kubernetes home lab on an old computer](https://www.youtube.com/watch?v=VKfE5BuqlSc)
- [VirtualBox: Creating Talos Kubernetes cluster using VirtualBox VMs](https://docs.siderolabs.com/talos/v1.9/platform-specific-installations/local-platforms/virtualbox)
- [Kubernetes home lab on an old computer](https://www.youtube.com/watch?v=VKfE5BuqlSc)
- https://docs.siderolabs.com/talos/v1.11/platform-specific-installations/local-platforms/virtualbox
- Multinode
  - https://docs.siderolabs.com/talos/v1.11/getting-started/prodnotes
  - https://docs.siderolabs.com/talos/v1.11/deploy-and-manage-workloads/scaling-up
  - https://docs.siderolabs.com/talos/v1.11/deploy-and-manage-workloads/scaling-down

## VirtualBox

Start VirtualBox VM with a **Bare-metal Machine** ISO from https://factory.talos.dev/ and providing the VM with a NAT network interface like this:

- NAT
- Host-only Adapter, 'vboxnet0'
  - Enabling a DHCP Server the VM will get the IP 192.168.56.3 (Lower Address Bound)
  - Alternative: use https://github.com/sfmunoz/i12e/blob/main/dev-tools/dhcpd.sh server

Connect:

```
$ talosctl get disks --insecure --nodes 192.168.56.3
```

## Usage

Help:

```
$ ./setup.sh

Usage:

  $ setup.sh config             (delete and create configuration)
  $ setup.sh install-1          (control-plane node)
  $ setup.sh install-2          (worker node)
  $ setup.sh install-3          (worker node)
  $ eval $(setup.sh source)
```

## Config generation

```
$ ./setup.sh config
+ mkdir -p cdev
+ rm -fv ./cdev/talosconfig ./cdev/controlplane.yaml ./cdev/worker.yaml
+ '[' -f ./cdev/secrets.yaml ']'
+ talosctl gen secrets -o ./cdev/secrets.yaml
+ talosctl gen config cdev https://192.168.56.57:6443 --with-secrets ./cdev/secrets.yaml --install-disk /dev/sda --output cdev --config-patch-control-plane @/dev/stdin
generating PKI and tokens
Created cdev/controlplane.yaml
Created cdev/worker.yaml
Created cdev/talosconfig
+ talosctl config endpoint 192.168.56.57
+ talosctl config node 192.168.56.57
```

## Install control-plane node

```
$ ./setup.sh install-1
+ talosctl apply-config --nodes 192.168.56.57 --file ./cdev/controlplane.yaml --insecure
Applied configuration without a reboot
+ true
+ talosctl bootstrap
error executing bootstrap: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing: dial tcp 192.168.56.57:50000: connect: connection refused"
+ sleep 10
+ true
(... several attempts ...)
+ talosctl bootstrap
+ break
+ rm -fv ./cdev/kubeconfig
+ talosctl kubeconfig
```

## Install worker nodes (optional)

```
$ ./setup.sh install-2
+ talosctl apply-config --nodes 192.168.56.58 --file ./cdev/worker.yaml --insecure
Applied configuration without a reboot
```
```
$ ./setup.sh install-3
+ talosctl apply-config --nodes 192.168.56.59 --file ./cdev/worker.yaml --insecure
Applied configuration without a reboot
```

## Connect

```
$ talosctl health
discovered nodes: ["10.0.2.15" "10.0.2.15" "10.0.2.15"]
waiting for etcd to be healthy: ...
waiting for etcd to be healthy: OK
waiting for etcd members to be consistent across nodes: ...
waiting for etcd members to be consistent across nodes: OK
waiting for etcd members to be control plane nodes: ...
waiting for etcd members to be control plane nodes: OK
waiting for apid to be ready: ...
waiting for apid to be ready: OK
waiting for all nodes memory sizes: ...
waiting for all nodes memory sizes: OK
waiting for all nodes disk sizes: ...
waiting for all nodes disk sizes: OK
waiting for no diagnostics: ...
waiting for no diagnostics: OK
waiting for kubelet to be healthy: ...
waiting for kubelet to be healthy: OK
waiting for all nodes to finish boot sequence: ...
waiting for all nodes to finish boot sequence: OK
waiting for all k8s nodes to report: ...
waiting for all k8s nodes to report: OK
waiting for all control plane static pods to be running: ...
waiting for all control plane static pods to be running: OK
waiting for all control plane components to be ready: ...
waiting for all control plane components to be ready: OK
waiting for all k8s nodes to report ready: ...
waiting for all k8s nodes to report ready: OK
waiting for kube-proxy to report ready: ...
waiting for kube-proxy to report ready: OK
waiting for coredns to report ready: ...
waiting for coredns to report ready: OK
waiting for all k8s nodes to report schedulable: ...
waiting for all k8s nodes to report schedulable: OK
```
```
$ kubectl get nodes
NAME   STATUS   ROLES           AGE     VERSION
fc7    Ready    control-plane   2m22s   v1.37.0
fc8    Ready    <none>          113s    v1.37.0
fc9    Ready    <none>          75s     v1.37.0
```
```
$ kubectl get pods -A -o wide
NAMESPACE     NAME                          READY   STATUS    RESTARTS        AGE     IP              NODE   NOMINATED NODE   READINESS GATES
kube-system   coredns-f98564579-57j4n       1/1     Running   1 (2m29s ago)   12m     10.244.0.4      fc7    <none>           <none>
kube-system   coredns-f98564579-97rzn       1/1     Running   1 (2m29s ago)   12m     10.244.0.5      fc7    <none>           <none>
kube-system   kube-apiserver-fc7            1/1     Running   0               47s     192.168.56.57   fc7    <none>           <none>
kube-system   kube-controller-manager-fc7   1/1     Running   2 (49s ago)     47s     192.168.56.57   fc7    <none>           <none>
kube-system   kube-flannel-mx6l8            1/1     Running   0               3m36s   10.0.2.15       fc8    <none>           <none>
kube-system   kube-flannel-tqbch            1/1     Running   0               3m19s   10.0.2.15       fc9    <none>           <none>
kube-system   kube-flannel-ztcrc            1/1     Running   1 (2m34s ago)   12m     192.168.56.57   fc7    <none>           <none>
kube-system   kube-proxy-gpl26              1/1     Running   0               3m19s   10.0.2.15       fc9    <none>           <none>
kube-system   kube-proxy-gwxs2              1/1     Running   1 (2m34s ago)   12m     192.168.56.57   fc7    <none>           <none>
kube-system   kube-proxy-m5ns9              1/1     Running   0               3m35s   10.0.2.15       fc8    <none>           <none>
kube-system   kube-scheduler-fc7            1/1     Running   2 (49s ago)     47s     192.168.56.57   fc7    <none>           <none>
```
