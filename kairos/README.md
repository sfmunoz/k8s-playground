# kairos

- [References](#references)
- [VirtualBox](#virtualbox)

## References

- https://kairos.io/
- https://github.com/kairos-io/kairos

## VirtualBox

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
- Kairos (manual)
- kairos (interactive install)
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
