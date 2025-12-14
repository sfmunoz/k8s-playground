#!/bin/bash

# Ref: https://kopf.readthedocs.io/en/stable/install/

[ "$CYCLES" = "" ] && CYCLES="2"
[ "$CLEANUP" = "" ] && CLEANUP="1"

set -e -o pipefail

cd "$(dirname "$0")"

../install.sh

set -x
# peering split into CRD and OBJ to prevent errors
kubectl apply -f 01-peering-crd.yaml
kubectl apply -f 02-peering-obj.yaml
kubectl apply -f 03-example-crd.yaml
{ set +x; } 2> /dev/null

../venv/bin/kopf run example.py --verbose &

KOPF_PID="$!"

for i in `seq 1 $(( 2 * CYCLES ))`
do
  CMD="apply"
  [ $(( i % 2 )) = 0 ] && CMD="delete"
  sleep 2
  echo "--------------------------------------------------------------------------------"
  set -x
  kubectl $CMD -f 04-example-obj.yaml
  { set +x; } 2> /dev/null
done

echo "--------------------------------------------------------------------------------"
set -x
kill -15 $KOPF_PID
{ set +x; } 2> /dev/null
sleep 1

[ "$CLEANUP" = "0" ] && exit

set -x
kubectl delete -f 03-example-crd.yaml
kubectl delete -f 02-peering-obj.yaml
kubectl delete -f 01-peering-crd.yaml
{ set +x; } 2> /dev/null
