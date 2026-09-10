#!/bin/bash

set -e -o pipefail

cd "$(dirname "$0")"

export KUBECONFIG="${HOME}/.kube/config.talos"
export TALOSCONFIG="./talosconfig"
export CONTROL_PLANE_IP="127.0.0.1"
export CLUSTER_NAME="c1"

set -x

rm -fv "$KUBECONFIG" controlplane.yaml talosconfig worker.yaml
talosctl gen config $CLUSTER_NAME https://${CONTROL_PLANE_IP}:6443
talosctl config endpoint $CONTROL_PLANE_IP
talosctl config node $CONTROL_PLANE_IP
talosctl get disks --insecure --nodes $CONTROL_PLANE_IP
# --nodes must be explicit
talosctl apply-config --nodes $CONTROL_PLANE_IP --file controlplane.yaml --insecure
sleep 90
talosctl bootstrap
talosctl kubeconfig
