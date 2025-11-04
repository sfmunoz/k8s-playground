# talos-docker

## talos-docker (vagrant)

Ref: https://www.talos.dev/

**Note**: use `talosctl config nodes ...` as described to avoid the following error in most of **talosctl** commands:

> *nodes are not set for the command: please use `--nodes` flag or configuration file to set the nodes to run the command against*

```
vagrant@vbox:~$ kubectl get nodes
NAME                           STATUS   ROLES           AGE   VERSION
talos-default-controlplane-1   Ready    control-plane   64m   v1.34.1
talos-default-worker-1         Ready    <none>          64m   v1.34.1

vagrant@vbox:~$ talosctl config info
Current context:     talos-default
Nodes:               not defined
Endpoints:           127.0.0.1:42875
Roles:               os:admin
Certificate expires: 1 year from now (2026-11-02)

vagrant@vbox:~$ talosctl config nodes talos-default-controlplane-1 talos-default-worker-1

vagrant@vbox:~$ talosctl config info
Current context:     talos-default
Nodes:               talos-default-controlplane-1, talos-default-worker-1
Endpoints:           127.0.0.1:42875
Roles:               os:admin
Certificate expires: 1 year from now (2026-11-02)
```

Usage:

```
$ vagrant up

$ vagrant ssh

vagrant@vbox:~$ talosctl cluster show
PROVISIONER           docker
NAME                  talos-default
NETWORK NAME          talos-default
NETWORK CIDR          10.5.0.0/24
NETWORK GATEWAY
NETWORK MTU           1500
KUBERNETES ENDPOINT   https://127.0.0.1:45687

NODES:

NAME                           TYPE           IP         CPU    RAM      DISK
talos-default-controlplane-1   controlplane   10.5.0.2   2.00   2.1 GB   -
talos-default-controlplane-2   controlplane   10.5.0.3   2.00   2.1 GB   -
talos-default-worker-1         worker         10.5.0.4   2.00   2.1 GB   -
talos-default-worker-2         worker         10.5.0.5   2.00   2.1 GB   -

vagrant@vbox:~$ kubectl get nodes
NAME                           STATUS   ROLES           AGE     VERSION
talos-default-controlplane-1   Ready    control-plane   9m24s   v1.34.1
talos-default-controlplane-2   Ready    control-plane   9m30s   v1.34.1
talos-default-worker-1         Ready    <none>          9m29s   v1.34.1
talos-default-worker-2         Ready    <none>          9m29s   v1.34.1
```
