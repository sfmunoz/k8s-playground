#!/bin/bash

export KUBECONFIG="${HOME}/.kube/config.talos"
export TALOSCONFIG="./talosconfig"
export CONTROL_PLANE_IP="127.0.0.1"

set -e -o pipefail

cd "$(dirname "$0")"

case "$1" in
config)
  [ "$CLUSTER_NAME" = "" ] && CLUSTER_NAME="cdev"
  export CLUSTER_NAME
  set -x
  rm -fv controlplane.yaml talosconfig worker.yaml
  [ -f secrets.yaml ] || talosctl gen secrets
  talosctl gen config $CLUSTER_NAME https://${CONTROL_PLANE_IP}:6443 \
    --with-secrets secrets.yaml \
    --output-types controlplane,talosconfig \
    --install-disk /dev/sda \
    --config-patch-control-plane @/dev/stdin <<__EOF
apiVersion: v1alpha1
kind: KubeNodeConfig
taints:
  node-role.kubernetes.io/control-plane:
    \$patch: delete
__EOF
  talosctl config endpoint $CONTROL_PLANE_IP
  talosctl config node $CONTROL_PLANE_IP
  #talosctl get disks --insecure --nodes $CONTROL_PLANE_IP
  ;;
install)
  set -x
  # --nodes must be explicit
  talosctl apply-config --nodes $CONTROL_PLANE_IP --file controlplane.yaml --insecure
  while true; do
    talosctl bootstrap && break
    sleep 10
  done
  rm -fv "$KUBECONFIG"
  talosctl kubeconfig
  ;;
source)
  cat <<__EOF
export KUBECONFIG="${HOME}/.kube/config.talos"
export TALOSCONFIG="./talosconfig"
__EOF
  ;;
*)
  BNAME="$(basename "$0")"
  echo
  echo "Usage:"
  echo
  echo "  \$ ${BNAME} config             (delete and create configuration)"
  echo "  \$ ${BNAME} install            (apply to a new cluster)"
  echo "  \$ eval \$(${BNAME} source)"
  echo
  ;;
esac
