# kairos

- [References](#references)
- [Kairos install (default)](#kairos-install-default)
- [Kairos install (manual)](#kairos-install-manual)
- [Binaries](#binaries)
  - [kairos](#kairos)
  - [kairos-agent](#kairos-agent)
  - [k3s](#k3s)

## References

- https://kairos.io/
- https://github.com/kairos-io/kairos

## Kairos install (default)

Ref: https://kairos.io/v3.5.6/docs/installation/webui/

**(1)** Download from [https://github.com/kairos-io/kairos/releases](https://github.com/kairos-io/kairos/releases):

- **kairos-rocky-9.6-standard-amd64-generic-v3.5.7-k3sv1.34.1+k3s1.iso**
- kairos-rocky-9.6-standard-amd64-generic-v3.5.7-k3sv1.34.1+k3s1.iso.sha256
- kairos-rocky-9.6-standard-amd64-generic-v3.5.7-k3sv1.34.1+k3s1.iso.sha256.sig (optional)

Didn't work for me (installer failed detecting HDs):

- kairos-debian-12-standard-amd64-generic-v3.5.7-k3sv1.34.1+k3s1.iso
- kairos-debian-12-standard-amd64-generic-v3.5.7-k3sv1.34.1+k3s1.iso.sha256

**(2)** Boot using **kairos-rocky-9.6-standard-amd64-generic-v3.5.7-k3sv1.34.1+k3s1.iso**:

- RAM: 2GB
- HD: 8GB
- 1 CPU

**(3)** Grub options:

- **Kairos** → default, I used this
- Kairos (manual) → root shell... you can use `kairos-agent interactive-install` to launch the installer (3rd option of this grub menu)
- kairos (interactive install) → this is pretty easy to use too (directly using the console)
- Kairos (remote recovery mode)
- Kairos (boot local node from livecd)
- Kairos (debug)

**(4)** HTTP interface (VirtualBox host-only network, direct access from host):

URL:

> http://192.168.56.20:8080/

Cloud config:

```yaml
#cloud-config

users:
- name: "kairos"
  passwd: "kairos"
  groups: ["admin"]
  ssh_authorized_keys:
  - "ssh-rsa AAAA..."

k3s:
  enabled: true
```

Settings:

- Device: auto → _like it was_
- `[ ]` Reboot after installation → _as it was_
- `[X]` Power off after installation → _checked this_

**(5)** Once halted power it off and remove the CD from the VM

**(6)** Start it with the default grub option (the first one):

- **Kairos** → default, I used this
- Kairos (fallback)
- Kairos recovery
- Kairos state reset (auto)
- Kairos remote recovery

**(7)** SSH (key/pass were set by **cloud-config**:

```
$ ssh kairos@192.168.56.20
Welcome to Kairos!

Refer to https://kairos.io for documentation.
Last login: Fri Nov  7 16:17:27 2025 from 192.168.56.1
[kairos@localhost ~]$ sudo kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
kube-system   coredns-7896679cc-z84vl                   1/1     Running     0          46s
kube-system   helm-install-traefik-crd-wc9d8            0/1     Completed   0          46s
kube-system   helm-install-traefik-qj5fp                0/1     Completed   2          46s
kube-system   local-path-provisioner-578895bd58-qjf5j   1/1     Running     0          46s
kube-system   metrics-server-7b9c9c4b9c-gws9c           1/1     Running     0          46s
kube-system   svclb-traefik-dc2b036c-nfdpx              2/2     Running     0          11s
kube-system   traefik-6f986b958c-dm96s                  1/1     Running     0          11s
```

## Kairos install (manual)

Ref: https://kairos.io/v3.5.6/docs/installation/manual/

**cloud-config** file on the host:

```
$ ls -l
-rw------- 1 sfm sfm 858 Nov  8 08:25 install.yaml

$ cat install.yaml
#cloud-config

users:
- name: "kairos"
  passwd: "kairos"
  groups: ["admin"]
  ssh_authorized_keys:
  - "ssh-rsa AAAA..."

k3s:
  enabled: true
```

HTTP server (host-only network):

```
$ busybox httpd -p 192.168.56.1:8080 -f -v
```

VM grub option → **Kairos (manual)**:

- Kairos
- **Kairos (manual)** → this one
- kairos (interactive install)
- Kairos (remote recovery mode)
- Kairos (boot local node from livecd)
- Kairos (debug)

Trigger installation:

```
kairos-agent manual-install --device auto --poweroff http://192.168.56.1:8080/install.yaml
```

> Alternative: `kairos-agent interactive-install` for a menu-based installation (like **kairos (interactive install)** grub option)

`--poweroff` option seems to be ignored so:

- Run `poweroff` command
- Remove ISO image from VM
- Start VM
- ssh to server: `ssh kairos@192.168.56.20`

Everything ready:

```
[kairos@localhost ~]$ sudo kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
kube-system   coredns-7896679cc-dfpld                   1/1     Running     0          86s
kube-system   helm-install-traefik-crd-rtgzd            0/1     Completed   0          86s
kube-system   helm-install-traefik-rg7rp                0/1     Completed   2          86s
kube-system   local-path-provisioner-578895bd58-7v988   1/1     Running     0          86s
kube-system   metrics-server-7b9c9c4b9c-mmhpt           1/1     Running     0          86s
kube-system   svclb-traefik-579d0cf2-5mj56              2/2     Running     0          51s
kube-system   traefik-6f986b958c-td9hc                  1/1     Running     0          51s
```
## Binaries

### kairos

```
$ kairos
NAME:
   kairos - kairos CLI to bootstrap, upgrade, connect and manage a kairos network

USAGE:
   kairos [global options] command [command options]

VERSION:
   v2.13.4

DESCRIPTION:

   The kairos CLI can be used to manage a kairos box and perform all day-two tasks, like:
   - register a node (WARNING: this command will be deprecated in the next release, use the kairosctl binary instead)
   - connect to a node in recovery mode
   - to establish a VPN connection
   - set, list roles
   - interact with the network API

   and much more.

   For all the example cases, see: https://kairos.io/docs/


AUTHOR:
   Ettore Di Giacinto

COMMANDS:
   recovery-ssh-server  Starts SSH recovery service
   register             Registers and bootstraps a node (WARNING: this command will be deprecated in the next release, use the kairosctl binary instead)
   bridge               Connect to a kairos VPN network (WARNING: this command will be deprecated in the next release, use the kairosctl binary instead)
   get-kubeconfig       Return a deployment kubeconfig
   role                 Set or list node roles
   create-config, c     Creates a pristine config file
   generate-token, g    Creates a new token
   validate             Validates a cloud config file
   version
   help, h              Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h     show help
   --version, -v  print the version

COPYRIGHT:
   Ettore Di Giacinto
```

### kairos-agent

```
$ kairos-agent
NAME:
   kairos-agent - kairos agent start

USAGE:
   kairos-agent [global options] command [command options]

VERSION:
   v2.24.9

DESCRIPTION:

   The kairos agent is a component to abstract away node ops, providing a common feature-set across kairos variants.


AUTHOR:
   Ettore Di Giacinto

COMMANDS:
   upgrade
   notify               notify <event> <config dir>...
   start, s             Starts the kairos agent
   install-bundle       Installs a kairos bundle
   uuid, u              Prints the local UUID
   webui, w             Starts the webui
   config, c            Shows the machine configuration
   state                get machine state
   render-template      Render a Go template
   interactive-install  Starts interactive installation
   manual-install, m    Starts the manual installation
   install, i           Starts the kairos pairing installation
   recovery, r          Starts kairos recovery mode
   reset                Starts kairos reset mode
   validate             Validates a cloud config file
   print-schema         Print out Kairos' Cloud Configuration JSON Schema
   run-stage            Run stage from cloud-init
   pull-image           Pull remote image to local file
   version              Print kairos-agent version
   versioneer           versioneer subcommands
   bootentry            bootentry [--select]
   grubedit             grubedit [set] KEY=VALUE
   sysext               sysext subcommands
   logs                 Collect logs from the system
   help, h              Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --strict-validation  Fail instead of warn on validation errors. (default: false) [$STRICT_VALIDATIONS]
   --debug              enable debug output (default: false) [$KAIROS_AGENT_DEBUG]
   --help, -h           show help
   --version, -v        print the version

COPYRIGHT:
   kairos authors
```

### k3s

```
$ k3s
NAME:
   k3s - Kubernetes, but small and simple

USAGE:
   k3s [global options] command [command options]

VERSION:
   v1.34.1+k3s1 (24fc436e)

COMMANDS:
   server           Run management server
   agent            Run node agent
   kubectl          Run kubectl
   crictl           Run crictl
   ctr              Run ctr
   check-config     Run config check
   token            Manage tokens
   etcd-snapshot    Manage etcd snapshots
   secrets-encrypt  Control secrets encryption and keys rotation
   certificate      Manage K3s certificates
   completion       Install shell completion script
   help, h          Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug                     (logging) Turn on debug logs (default: false) [$K3S_DEBUG]
   --data-dir value, -d value  (data) Folder to hold state default /var/lib/rancher/k3s or ${HOME}/.rancher/k3s if not root [$K3S_DATA_DIR]
   --help, -h                  show help
   --version, -v               print the version
```
