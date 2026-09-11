#!/bin/bash

set -e -o pipefail

cd "$(dirname "$0")"

[ "$CLUSTER_NAME" = "" ] && CLUSTER_NAME="cdev"
[ "$CONTROL_PLANE_IP" = "" ] && CONTROL_PLANE_IP="127.0.0.1"

export CLUSTER_NAME CONTROL_PLANE_IP

export KUBECONFIG="./${CLUSTER_NAME}/kubeconfig"
export TALOSCONFIG="./${CLUSTER_NAME}/talosconfig"

CONTROLPLANE_YAML="./${CLUSTER_NAME}/controlplane.yaml"
WORKER_YAML="./${CLUSTER_NAME}/worker.yaml"

case "$1" in
config)
  SECRETS_YAML="./${CLUSTER_NAME}/secrets.yaml"
  set -x
  mkdir -p "${CLUSTER_NAME}"
  rm -fv "$TALOSCONFIG" "$CONTROLPLANE_YAML" "$WORKER_YAML"
  [ -f "${SECRETS_YAML}" ] || talosctl gen secrets -o "${SECRETS_YAML}"
  talosctl gen config $CLUSTER_NAME https://${CONTROL_PLANE_IP}:6443 \
    --with-secrets "${SECRETS_YAML}" \
    --install-disk /dev/sda \
    --output "${CLUSTER_NAME}" \
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
  talosctl apply-config --nodes $CONTROL_PLANE_IP --file "$CONTROLPLANE_YAML" --insecure
  while true; do
    talosctl bootstrap && break
    sleep 10
  done
  rm -fv "$KUBECONFIG"
  talosctl kubeconfig
  ;;
source)
  cat <<__EOF
export KUBECONFIG="$KUBECONFIG"
export TALOSCONFIG="$TALOSCONFIG"
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
