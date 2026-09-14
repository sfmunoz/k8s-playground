#!/bin/bash

set -e -o pipefail

cd "$(dirname "$0")"

[ "$CLUSTER_NAME" = "" ] && CLUSTER_NAME="cdev"
[ "$IP1" = "" ] && IP1="192.168.56.57"
[ "$IP2" = "" ] && IP2="192.168.56.58"
[ "$IP3" = "" ] && IP3="192.168.56.59"

IPS=("----" "$IP1" "$IP2" "$IP3")

export CLUSTER_NAME

export KUBECONFIG="./${CLUSTER_NAME}/kubeconfig"
export TALOSCONFIG="./${CLUSTER_NAME}/talosconfig"
SECRETS_YAML="./${CLUSTER_NAME}/secrets.yaml"

function gen_config {
  CFG_NAME="$1"
  case "$CFG_NAME" in
  node1)
    OUTPUT_TYPES="controlplane"
    ;;
  node2 | node3)
    OUTPUT_TYPES="worker"
    ;;
  talosconfig)
    OUTPUT_TYPES="talosconfig"
    ;;
  *)
    echo "error: unsupported '$1' argument"
    exit 1
    ;;
  esac
  set -x
  talosctl gen config $CLUSTER_NAME https://${IPS[1]}:6443 \
    --with-secrets <(
      { set +x; } 2>/dev/null
      sops decrypt "${SECRETS_YAML}"
    ) \
    --install-disk /dev/sda \
    --output - \
    --output-types "${OUTPUT_TYPES}" \
    --config-patch <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patches/common.yaml
      case "$CFG_NAME" in
      node1 | node2 | node3)
        echo "---"
        sops decrypt "${CLUSTER_NAME}/wg${CFG_NAME#node}.yaml"
        ;;
      esac
      [ -f wg.yaml ] || exit 0
      echo "---"
      sops decrypt wg.yaml
    ) \
    --config-patch-control-plane <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patches/control-plane.yaml
    ) \
    --config-patch-worker <(
      { set +x; } 2>/dev/null
      echo "---"
      cat patches/worker.yaml
    )
}

CMD="$1"

case "$CMD" in
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
mesh)
  set -x -e -o pipefail
  cd "${CLUSTER_NAME}"
  ../mesh.py ${IPS[1]}:51823 ${IPS[2]}:51823 ${IPS[3]}:51823
  cd ..
  ;;
talosconfig)
  set -x
  gen_config talosconfig >"${TALOSCONFIG}"
  talosctl config endpoint ${IPS[1]}
  talosctl config node ${IPS[1]} ${IPS[2]} ${IPS[3]}
  ;;
debug-1 | debug-2 | debug-3)
  set -x
  N="${CMD#debug-}"
  NODE="node$N"
  gen_config $NODE
  ;;
install-1)
  set -x
  talosctl apply-config --nodes ${IPS[1]} --file <(gen_config node1) --insecure
  while true; do
    talosctl bootstrap --nodes ${IPS[1]} && break
    sleep 10
  done
  ;;
update-1 | update-2 | update-3)
  set -x
  N="${CMD#update-}"
  NODE="node$N"
  talosctl apply-config --nodes ${IPS[$N]} --file <(gen_config $NODE)
  ;;
try-1 | try-2 | try-3)
  set -x
  N="${CMD#try-}"
  NODE="node$N"
  talosctl apply-config --nodes ${IPS[$N]} --file <(gen_config $NODE) --mode try
  ;;
kubeconfig)
  set -x
  talosctl kubeconfig --nodes ${IPS[1]}
  ;;
install-2)
  set -x
  talosctl apply-config --nodes ${IPS[2]} --file <(gen_config node2) --insecure
  ;;
install-3)
  set -x
  talosctl apply-config --nodes ${IPS[3]} --file <(gen_config node3) --insecure
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
  echo "  \$ ${BNAME} mesh                           -- mesh gen"
  echo "  \$ ${BNAME} talosconfig                    -- talosconfig gen"
  echo "  \$ ${BNAME} install-1                      -- control-plane node"
  echo "  \$ ${BNAME} kubeconfig                     -- kubeconfig gen"
  echo "  \$ ${BNAME} install-2                      -- worker node"
  echo "  \$ ${BNAME} install-3                      -- worker node"
  echo "  \$ ${BNAME} debug-1/debug-2/debug-3        -- debug config"
  echo "  \$ ${BNAME} try-1/try-2/try-3              -- try config"
  echo "  \$ ${BNAME} update-1/update-2/update-3     -- update config"
  echo "  \$ eval \$(${BNAME} source)                 -- set KUBECONFIG/TALOSCONFIG env vars"
  echo
  ;;
esac
