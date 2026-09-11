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

- NAT + port-forward:
  - talos: 127.0.0.1:50000 → 50000 (guest IP blank)
  - k8s: 127.0.0.1:6443 → 6443 (guest IP blank)
- `export CONTROL_PLANE_IP=127.0.0.1`
- `talosctl get disks --insecure --nodes $CONTROL_PLANE_IP`

Alternative:

- Host-only Adapter, 'vboxnet0'
  - Enabling a DHCP Server the VM will get the IP 192.168.56.3 (Lower Address Bound)
- NAT

## Usage

Help:

```
$ ./setup.sh

Usage:

  $ setup.sh config             (delete and create configuration)
  $ setup.sh install            (apply to a new cluster)
  $ eval $(setup.sh source)
```

## Config generation

```
./setup.sh config
+ mkdir -p cdev
+ rm -fv ./cdev/talosconfig ./cdev/controlplane.yaml ./cdev/worker.yaml
+ '[' -f ./cdev/secrets.yaml ']'
+ talosctl gen secrets -o ./cdev/secrets.yaml
+ talosctl gen config cdev https://127.0.0.1:6443 --with-secrets ./cdev/secrets.yaml --output-types controlplane,talosconfig --install-disk /dev/sda --output cdev --config-patch-control-plane @/dev/stdin
generating PKI and tokens
Created cdev/controlplane.yaml
Created cdev/talosconfig
+ talosctl config endpoint 127.0.0.1
+ talosctl config node 127.0.0.1
```

## Install

```
$ ./setup.sh install
+ talosctl apply-config --nodes 127.0.0.1 --file ./cdev/controlplane.yaml --insecure
Applied configuration without a reboot
+ true
+ talosctl bootstrap
error executing bootstrap: rpc error: code = Unavailable desc = connection error: desc = "transport: authentication handshake failed: EOF"
+ sleep 10
+ true
(... several attempts ...)
+ talosctl bootstrap
+ break
+ rm -fv ./cdev/kubeconfig
+ talosctl kubeconfig
```

## Connect

When **READY=True** in the VM console:

```
$ talosctl health
discovered nodes: ["10.0.2.15"]
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
$ kubectl get pods -A
NAMESPACE     NAME                                    READY   STATUS    RESTARTS      AGE
kube-system   coredns-f98564579-bfkh4                 1/1     Running   0             58s
kube-system   coredns-f98564579-bl52k                 1/1     Running   0             58s
kube-system   kube-apiserver-talos-2jh-qih            1/1     Running   0             40s
kube-system   kube-controller-manager-talos-2jh-qih   1/1     Running   3 (91s ago)   40s
kube-system   kube-flannel-ktbrv                      1/1     Running   0             53s
kube-system   kube-proxy-77zbw                        1/1     Running   0             53s
kube-system   kube-scheduler-talos-2jh-qih            1/1     Running   3 (91s ago)   40s
```
