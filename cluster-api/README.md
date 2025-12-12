# cluster-api

- [References](#references)
- [clusterctl repositories](#clusterctl-repositories)
- [Vanilla example](#vanilla-example)
- [Image Builder (Vultr)](#image-builder-vultr)

## References

- [https://cluster-api.sigs.k8s.io/](https://cluster-api.sigs.k8s.io/)
- [https://github.com/kubernetes-sigs/cluster-api](https://github.com/kubernetes-sigs/cluster-api)

Extra refs:

- https://github.com/k3s-io/cluster-api-k3s
  - Cluster API Bootstrap Provider k3s (CABP3)
  - Cluster API ControlPlane Provider k3s (CACP3)
 
## clusterctl repositories

```
$ clusterctl config repositories
NAME                    TYPE                       URL                                                                                               FILE
cluster-api             CoreProvider               https://github.com/kubernetes-sigs/cluster-api/releases/latest/                                   core-components.yaml
canonical-kubernetes    BootstrapProvider          https://github.com/canonical/cluster-api-k8s/releases/latest/                                     bootstrap-components.yaml
k0sproject-k0smotron    BootstrapProvider          https://github.com/k0sproject/k0smotron/releases/latest/                                          bootstrap-components.yaml
kubeadm                 BootstrapProvider          https://github.com/kubernetes-sigs/cluster-api/releases/latest/                                   bootstrap-components.yaml
kubekey-k3s             BootstrapProvider          https://github.com/kubesphere/kubekey/releases/latest/                                            bootstrap-components.yaml
microk8s                BootstrapProvider          https://github.com/canonical/cluster-api-bootstrap-provider-microk8s/releases/latest/             bootstrap-components.yaml
rke2                    BootstrapProvider          https://github.com/rancher/cluster-api-provider-rke2/releases/latest/                             bootstrap-components.yaml
talos                   BootstrapProvider          https://github.com/siderolabs/cluster-api-bootstrap-provider-talos/releases/latest/               bootstrap-components.yaml
canonical-kubernetes    ControlPlaneProvider       https://github.com/canonical/cluster-api-k8s/releases/latest/                                     control-plane-components.yaml
k0sproject-k0smotron    ControlPlaneProvider       https://github.com/k0sproject/k0smotron/releases/latest/                                          control-plane-components.yaml
kamaji                  ControlPlaneProvider       https://github.com/clastix/cluster-api-control-plane-provider-kamaji/releases/latest/             control-plane-components.yaml
kubeadm                 ControlPlaneProvider       https://github.com/kubernetes-sigs/cluster-api/releases/latest/                                   control-plane-components.yaml
kubekey-k3s             ControlPlaneProvider       https://github.com/kubesphere/kubekey/releases/latest/                                            control-plane-components.yaml
microk8s                ControlPlaneProvider       https://github.com/canonical/cluster-api-control-plane-provider-microk8s/releases/latest/         control-plane-components.yaml
nested                  ControlPlaneProvider       https://github.com/kubernetes-sigs/cluster-api-provider-nested/releases/latest/                   control-plane-components.yaml
rke2                    ControlPlaneProvider       https://github.com/rancher/cluster-api-provider-rke2/releases/latest/                             control-plane-components.yaml
talos                   ControlPlaneProvider       https://github.com/siderolabs/cluster-api-control-plane-provider-talos/releases/latest/           control-plane-components.yaml
aws                     InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/latest/                      infrastructure-components.yaml
azure                   InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-azure/releases/latest/                    infrastructure-components.yaml
byoh                    InfrastructureProvider     https://github.com/vmware-tanzu/cluster-api-provider-bringyourownhost/releases/latest/            infrastructure-components.yaml
cloudstack              InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-cloudstack/releases/latest/               infrastructure-components.yaml
coxedge                 InfrastructureProvider     https://github.com/coxedge/cluster-api-provider-coxedge/releases/latest/                          infrastructure-components.yaml
digitalocean            InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-digitalocean/releases/latest/             infrastructure-components.yaml
docker                  InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api/releases/latest/                                   infrastructure-components-development.yaml
gcp                     InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-gcp/releases/latest/                      infrastructure-components.yaml
harvester-harvester     InfrastructureProvider     https://github.com/rancher-sandbox/cluster-api-provider-harvester/releases/latest/                infrastructure-components.yaml
hetzner                 InfrastructureProvider     https://github.com/syself/cluster-api-provider-hetzner/releases/latest/                           infrastructure-components.yaml
hivelocity-hivelocity   InfrastructureProvider     https://github.com/hivelocity/cluster-api-provider-hivelocity/releases/latest/                    infrastructure-components.yaml
huawei                  InfrastructureProvider     https://github.com/HuaweiCloudDeveloper/cluster-api-provider-huawei/releases/latest/              infrastructure-components.yaml
ibmcloud                InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-ibmcloud/releases/latest/                 infrastructure-components.yaml
ionoscloud-ionoscloud   InfrastructureProvider     https://github.com/ionos-cloud/cluster-api-provider-ionoscloud/releases/latest/                   infrastructure-components.yaml
k0sproject-k0smotron    InfrastructureProvider     https://github.com/k0sproject/k0smotron/releases/latest/                                          infrastructure-components.yaml
kubekey                 InfrastructureProvider     https://github.com/kubesphere/kubekey/releases/latest/                                            infrastructure-components.yaml
kubevirt                InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-kubevirt/releases/latest/                 infrastructure-components.yaml
linode-linode           InfrastructureProvider     https://github.com/linode/cluster-api-provider-linode/releases/latest/                            infrastructure-components.yaml
maas                    InfrastructureProvider     https://github.com/spectrocloud/cluster-api-provider-maas/releases/latest/                        infrastructure-components.yaml
metal3                  InfrastructureProvider     https://github.com/metal3-io/cluster-api-provider-metal3/releases/latest/                         infrastructure-components.yaml
nested                  InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-nested/releases/latest/                   infrastructure-components.yaml
nutanix                 InfrastructureProvider     https://github.com/nutanix-cloud-native/cluster-api-provider-nutanix/releases/latest/             infrastructure-components.yaml
oci                     InfrastructureProvider     https://github.com/oracle/cluster-api-provider-oci/releases/latest/                               infrastructure-components.yaml
opennebula              InfrastructureProvider     https://github.com/OpenNebula/cluster-api-provider-opennebula/releases/latest/                    infrastructure-components.yaml
openstack               InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-openstack/releases/latest/                infrastructure-components.yaml
outscale                InfrastructureProvider     https://github.com/outscale/cluster-api-provider-outscale/releases/latest/                        infrastructure-components.yaml
proxmox                 InfrastructureProvider     https://github.com/ionos-cloud/cluster-api-provider-proxmox/releases/latest/                      infrastructure-components.yaml
scaleway                InfrastructureProvider     https://github.com/scaleway/cluster-api-provider-scaleway/releases/latest/                        infrastructure-components.yaml
sidero                  InfrastructureProvider     https://github.com/siderolabs/sidero/releases/latest/                                             infrastructure-components.yaml
tinkerbell-tinkerbell   InfrastructureProvider     https://github.com/tinkerbell/cluster-api-provider-tinkerbell/releases/latest/                    infrastructure-components.yaml
vcd                     InfrastructureProvider     https://github.com/vmware/cluster-api-provider-cloud-director/releases/latest/                    infrastructure-components.yaml
vcluster                InfrastructureProvider     https://github.com/loft-sh/cluster-api-provider-vcluster/releases/latest/                         infrastructure-components.yaml
virtink                 InfrastructureProvider     https://github.com/smartxworks/cluster-api-provider-virtink/releases/latest/                      infrastructure-components.yaml
vsphere                 InfrastructureProvider     https://github.com/kubernetes-sigs/cluster-api-provider-vsphere/releases/latest/                  infrastructure-components.yaml
vultr-vultr             InfrastructureProvider     https://github.com/vultr/cluster-api-provider-vultr/releases/latest/                              infrastructure-components.yaml
in-cluster              IPAMProvider               https://github.com/kubernetes-sigs/cluster-api-ipam-provider-in-cluster/releases/latest/          ipam-components.yaml
metal3                  IPAMProvider               https://github.com/metal3-io/ip-address-manager/releases/latest/                                  ipam-components.yaml
nutanix                 IPAMProvider               https://github.com/nutanix-cloud-native/cluster-api-ipam-provider-nutanix/releases/latest/        ipam-components.yaml
nutanix                 RuntimeExtensionProvider   https://github.com/nutanix-cloud-native/cluster-api-runtime-extensions-nutanix/releases/latest/   runtime-extensions-components.yaml
eitco-cdk8s             AddonProvider              https://github.com/eitco/cluster-api-addon-provider-cdk8s/releases/latest/                        addon-components.yaml
helm                    AddonProvider              https://github.com/kubernetes-sigs/cluster-api-addon-provider-helm/releases/latest/               addon-components.yaml
rancher-fleet           AddonProvider              https://github.com/rancher/cluster-api-addon-provider-fleet/releases/latest/                      addon-components.yaml
```

## Vanilla example

kind cluster creation:
```
$ kind create cluster --name dev --wait 5m
Creating cluster "dev" ...
 ✓ Ensuring node image (kindest/node:v1.34.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Waiting ≤ 5m0s for control-plane = Ready ⏳
 • Ready after 17s 💚
Set kubectl context to "kind-dev"
You can now use your cluster with:

kubectl cluster-info --context kind-dev

Have a nice day! 👋

$ kubectl get nodes
NAME                STATUS   ROLES           AGE     VERSION
dev-control-plane   Ready    control-plane   2m17s   v1.34.0
```
clusterctl init:
```
$ clusterctl init
Fetching providers
Installing cert-manager version="v1.19.1"
(... some unrecognized format "int32/int64" messages ...)
Waiting for cert-manager to be available...
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
Installing provider="cluster-api" version="v1.12.0" targetNamespace="capi-system"
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
(... some unrecognized format "int32/int64" messages ...)
Installing provider="bootstrap-kubeadm" version="v1.12.0" targetNamespace="capi-kubeadm-bootstrap-system"
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
(... some unrecognized format "int32/int64" messages ...)
Installing provider="control-plane-kubeadm" version="v1.12.0" targetNamespace="capi-kubeadm-control-plane-system"
spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
(... some unrecognized format "int32/int64" messages ...)

Your management cluster has been initialized successfully!

You can now create your first workload cluster by running the following:

  clusterctl generate cluster [name] --kubernetes-version [version] | kubectl apply -f -
```
Pods:
```
$ kubectl get pods -A
NAMESPACE                           NAME                                                             READY   STATUS    RESTARTS   AGE
capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-85c4dc5b49-qkkzk       1/1     Running   0          4m52s
capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-7d6898fbff-rq2jl   1/1     Running   0          4m51s
capi-system                         capi-controller-manager-57ff69ccd4-s7x7w                         1/1     Running   0          4m52s
cert-manager                        cert-manager-69fd4bc5fc-jvphk                                    1/1     Running   0          5m8s
cert-manager                        cert-manager-cainjector-85b6d7fc67-dpkhc                         1/1     Running   0          5m8s
cert-manager                        cert-manager-webhook-cfbc49fc8-ddtzs                             1/1     Running   0          5m8s
(...)
```
## Image Builder (Vultr)

Ref: [https://github.com/vultr/cluster-api-provider-vultr](https://github.com/vultr/cluster-api-provider-vultr)

- CAPVULTR v1beta1 (v0.1.0)
- https://github.com/vultr/cluster-api-provider-vultr/blob/main/docs/getting-started.md
  - https://github.com/kubernetes-sigs/image-builder
    - **WARNING**: in my opinion it's quite intrusive since it begins installing **Ansible**, **packer** and the like without prior notice!!
    - It's better to use a disposable VM in order to avoid all the clutter

API KEY at https://my.vultr.com/ → Account → API → Personal Access Tokens:
```
$  export VULTR_API_KEY="...generated at https://vultr.com yourapikey
```
Setup:
```
$ git clone https://github.com/kubernetes-sigs/image-builder.git

$ cd image-builder/images/capi

$ make help | grep vultr
  deps-vultr                           Installs/checks dependencies for Vultr builds
  build-vultr-ubuntu-2204              Builds Ubuntu 22.04 Vultr Snapshot
  build-vultr-ubuntu-2404              Builds Ubuntu 24.04 Vultr Snapshot
  validate-vultr-ubuntu-2204           Validates Ubuntu 22.04 Vultr Snapshot Packer config
  validate-vultr-ubuntu-2404           Validates Ubuntu 24.04 Vultr Snapshot Packer config
```
Here comes the clutter (no questions asked):
```
$ make build-vultr-ubuntu-2204
hack/ensure-python.sh
Checking if python is available
Python 3.12.3
hack/ensure-ansible.sh
warning: externally-managed-environment, retrying pip3 install with --break-system-packages
Collecting ansible-core==2.15.13
  Using cached ansible_core-2.15.13-py3-none-any.whl.metadata (7.0 kB)
Requirement already satisfied: jinja2>=3.0.0 in /usr/lib/python3/dist-packages (from ansible-core==2.15.13) (3.1.2)
Requirement already satisfied: PyYAML>=5.1 in /usr/lib/python3/dist-packages (from ansible-core==2.15.13) (6.0.1)
Requirement already satisfied: cryptography in /usr/lib/python3/dist-packages (from ansible-core==2.15.13) (41.0.7)
Requirement already satisfied: packaging in /usr/lib/python3/dist-packages (from ansible-core==2.15.13) (24.0)
Collecting resolvelib<1.1.0,>=0.5.3 (from ansible-core==2.15.13)
  Using cached resolvelib-1.0.1-py2.py3-none-any.whl.metadata (4.0 kB)
Using cached ansible_core-2.15.13-py3-none-any.whl (2.3 MB)
Using cached resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Installing collected packages: resolvelib, ansible-core
Successfully installed ansible-core-2.15.13 resolvelib-1.0.1
ansible [core 2.15.13]
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/ansible-posix-2.1.0.tar.gz to /home/sfm/.ansible/tmp/ansible-local-285281iwf_12x/tmpq_i6mzly/ansible-posix-2.1.0-e6bukkj2
Installing 'ansible.posix:2.1.0' to '/home/sfm/.ansible/collections/ansible_collections/ansible/posix'
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/ansible-windows-3.3.0.tar.gz to /home/sfm/.ansible/tmp/ansible-local-285281iwf_12x/tmpq_i6mzly/ansible-windows-3.3.0-mqxhpuhj
ansible.posix:2.1.0 was installed successfully
Installing 'ansible.windows:3.3.0' to '/home/sfm/.ansible/collections/ansible_collections/ansible/windows'
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/community-windows-3.1.0.tar.gz to /home/sfm/.ansible/tmp/ansible-local-285281iwf_12x/tmpq_i6mzly/community-windows-3.1.0-yvnym1ub
ansible.windows:3.3.0 was installed successfully
Installing 'community.windows:3.1.0' to '/home/sfm/.ansible/collections/ansible_collections/community/windows'
Downloading https://galaxy.ansible.com/api/v3/plugin/ansible/content/published/collections/artifacts/community-general-11.4.2.tar.gz to /home/sfm/.ansible/tmp/ansible-local-285281iwf_12x/tmpq_i6mzly/community-general-11.4.2-gd8pc0wt
community.windows:3.1.0 was installed successfully
Installing 'community.general:11.4.2' to '/home/sfm/.ansible/collections/ansible_collections/community/general'
community.general:11.4.2 was installed successfully
hack/ensure-packer.sh
Installing packer v1.9.5 in .local/bin
packer_1.9.5_linux_amd64.zip: OK
Archive:  packer_1.9.5_linux_amd64.zip
  inflating: packer
'packer' has been installed to /home/sfm/src/image-builder/images/capi/.local/bin, make sure this directory is in your $PATH
/home/sfm/src/image-builder/images/capi/.local/bin/packer init packer/config.pkr.hcl
/home/sfm/src/image-builder/images/capi/.local/bin/packer init packer/vultr/config.pkr.hcl
/home/sfm/src/image-builder/images/capi/.local/bin/packer build -var-file="/home/sfm/src/image-builder/images/capi/packer/config/kubernetes.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/cni.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/containerd.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/wasm-shims.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/ansible-args.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/goss-args.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/common.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/additional_components.json"  -var-file="/home/sfm/src/image-builder/images/capi/packer/config/ecr_credential_provider.json"  -color=true -var-file="/home/sfm/src/image-builder/images/capi/packer/vultr/ubuntu-2204.json"  packer/vultr/packer.json
(... it takes ages to apply the playbook ...)
==> vultr: Performing graceful shutdown...
==> vultr: Sleeping to ensure that server is shut down...
==> vultr: Waiting 600s for snapshot 2b0d... to complete...
==> vultr: Destroying server 353a...
==> vultr: Deleting temporary SSH key...
Build 'vultr' finished after 22 minutes 29 seconds.

==> Wait completed after 22 minutes 29 seconds

==> Builds finished. The artifacts of successful builds are:
--> vultr: Vultr Snapshot: Cluster API Kubernetes v1.32.4 on Ubuntu 22.04  (2b0d...)
```
**NOTICE**: I'm not going any further here... https://github.com/vultr/cluster-api-provider-vultr/blob/main/docs/getting-started.md procedure will be completed should Cluster API support is required
