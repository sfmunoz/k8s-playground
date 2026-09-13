#!/bin/bash

set -e -o pipefail

cd "$(dirname "$0")"

[ "$CLUSTER_NAME" = "" ] && CLUSTER_NAME="cdev"
[ "$IP1" = "" ] && IP1="192.168.56.57"
[ "$IP2" = "" ] && IP2="192.168.56.58"
[ "$IP3" = "" ] && IP3="192.168.56.59"

export CLUSTER_NAME

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
  [ -f "${SECRETS_YAML}" ] ||
    talosctl gen secrets -o - |
    sops encrypt --filename-override secrets.yaml --output "${SECRETS_YAML}"
  talosctl gen config $CLUSTER_NAME https://${IP1}:6443 \
    --with-secrets <(sops decrypt "${SECRETS_YAML}") \
    --install-disk /dev/sda \
    --output "${CLUSTER_NAME}" \
    --config-patch <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patch-common.yaml
      [ -f wg.yaml ] || exit 0
      echo "---"
      sops decrypt wg.yaml
    ) \
    --config-patch-control-plane <(
      { set +x; } 2>/dev/null
      cat <<__EOF
apiVersion: v1alpha1
kind: KubeNodeConfig
taints:
  node-role.kubernetes.io/control-plane:
    \$patch: delete
---
cluster:
  etcd:
    advertisedSubnets:
    - 192.168.56.0/24
__EOF
    )
  talosctl config endpoint $IP1
  talosctl config node $IP1 $IP2 $IP3
  #talosctl get disks --insecure --nodes $IP1
  ;;
install-1)
  set -x
  # --nodes must be explicit
  talosctl apply-config --nodes $IP1 --file "$CONTROLPLANE_YAML" --insecure
  while true; do
    talosctl bootstrap --nodes $IP1 && break
    sleep 10
  done
  rm -fv "$KUBECONFIG"
  talosctl kubeconfig --nodes $IP1
  ;;
install-2)
  set -x
  talosctl apply-config --nodes $IP2 --file "${WORKER_YAML}" --insecure
  ;;
install-3)
  set -x
  talosctl apply-config --nodes $IP3 --file "${WORKER_YAML}" --insecure
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
  echo "  \$ ${BNAME} install-1          (control-plane node)"
  echo "  \$ ${BNAME} install-2          (worker node)"
  echo "  \$ ${BNAME} install-3          (worker node)"
  echo "  \$ eval \$(${BNAME} source)"
  echo
  ;;
esac
