#!/bin/bash

# Ref: https://kopf.readthedocs.io/en/stable/install/

DNAME="vpy"

set -e -o pipefail

cd "$(dirname "$0")"

set -x
[ -d "$DNAME" ] || python3 -m virtualenv "$DNAME"

"${DNAME}/bin/pip3" install kopf

kubectl apply -f https://github.com/nolar/kopf/raw/main/peering.yaml
kubectl apply -f https://github.com/nolar/kopf/raw/main/examples/crd.yaml
