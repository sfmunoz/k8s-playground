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
SECRETS_YAML="./${CLUSTER_NAME}/secrets.yaml"

function gen_config {
  case "$1" in
  debug)
    OUTPUT_TYPES="controlplane,worker,talosconfig"
    OUTPUT="${CLUSTER_NAME}-$(date +%Y%m%d%H%M%S)"
    rm -rf "${OUTPUT}"
    mkdir -p "${OUTPUT}"
    ;;
  controlplane | worker | talosconfig)
    OUTPUT_TYPES="$1"
    OUTPUT="-"
    ;;
  *)
    echo "error: unsupported '$1' argument"
    exit 1
    ;;
  esac
  set -x
  talosctl gen config $CLUSTER_NAME https://${IP1}:6443 \
    --with-secrets <(
      { set +x; } 2>/dev/null
      sops decrypt "${SECRETS_YAML}"
    ) \
    --install-disk /dev/sda \
    --output "${OUTPUT}" \
    --output-types "${OUTPUT_TYPES}" \
    --config-patch <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patch/common.yaml
      [ -f wg.yaml ] || exit 0
      echo "---"
      sops decrypt wg.yaml
    ) \
    --config-patch-control-plane <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patch/control-plane.yaml
    ) \
    --config-patch-worker <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patch/worker.yaml
    )
}
case "$1" in
secrets)
  set -x
  mkdir -p "$(
    { set +x; } 2>/dev/null
    dirname "${SECRETS_YAML}"
  )"
  rm -f "${SECRETS_YAML}"
  talosctl gen secrets -o - |
    sops encrypt --filename-override secrets.yaml --output "${SECRETS_YAML}"
  ;;
talosconfig)
  set -x
  gen_config talosconfig >"${TALOSCONFIG}"
  talosctl config endpoint $IP1
  talosctl config node $IP1 $IP2 $IP3
  ;;
install-1)
  set -x
  talosctl apply-config --nodes $IP1 --file <(gen_config controlplane) --insecure
  while true; do
    talosctl bootstrap --nodes $IP1 && break
    sleep 10
  done
  ;;
update-1)
  set -x
  talosctl apply-config --nodes $IP1 --file <(gen_config controlplane)
  ;;
try-1)
  set -x
  talosctl apply-config --nodes $IP1 --file <(gen_config controlplane) --mode try
  ;;
kubeconfig)
  set -x
  talosctl kubeconfig --nodes $IP1
  ;;
install-2)
  set -x
  talosctl apply-config --nodes $IP2 --file <(gen_config worker) --insecure
  ;;
update-2)
  set -x
  talosctl apply-config --nodes $IP2 --file <(gen_config worker)
  ;;
try-2)
  set -x
  talosctl apply-config --nodes $IP2 --file <(gen_config worker) --mode try
  ;;
install-3)
  set -x
  talosctl apply-config --nodes $IP3 --file <(gen_config worker) --insecure
  ;;
update-3)
  set -x
  talosctl apply-config --nodes $IP3 --file <(gen_config worker)
  ;;
try-3)
  set -x
  talosctl apply-config --nodes $IP3 --file <(gen_config worker) --mode try
  ;;
debug)
  set -x
  gen_config debug
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
  echo "Usage (order matters):"
  echo
  echo "  \$ ${BNAME} secrets                        -- secrets gen"
  echo "  \$ ${BNAME} talosconfig                    -- talosconfig gen"
  echo "  \$ ${BNAME} install-1                      -- control-plane node"
  echo "  \$ ${BNAME} kubeconfig                     -- kubeconfig gen"
  echo "  \$ ${BNAME} install-2                      -- worker node"
  echo "  \$ ${BNAME} install-3                      -- worker node"
  echo "  \$ ${BNAME} debug                          -- generate debug folder"
  echo "  \$ ${BNAME} try-1/try-2/try-3              -- try config"
  echo "  \$ ${BNAME} update-1/update-2/update-3     -- update config"
  echo "  \$ eval \$(${BNAME} source)                 -- set KUBECONFIG/TALOSCONFIG env vars"
  echo
  ;;
esac
