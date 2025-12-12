#!/bin/bash

# Ref: https://kopf.readthedocs.io/en/stable/install/

DNAME="vpy"

set -e -o pipefail

cd "$(dirname "$0")"

set -x
[ -d "$DNAME" ] || python3 -m virtualenv "$DNAME"

"${DNAME}/bin/pip3" install kopf

# peering split into CRD and OBJ to prevent errors
kubectl apply -f 01-peering-crd.yaml
kubectl apply -f 02-peering-obj.yaml
kubectl apply -f 03-example-crd.yaml

# apply/delete 04-example-obj.yaml once kopf is running
#kubectl apply -f 04-example-obj.yaml
