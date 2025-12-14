#!/bin/bash

set -e -o pipefail
cd "$(dirname "$0")"
../install.sh

set -x
kubectl apply -f widget-rd.yaml
kubectl delete --ignore-not-found configmaps large-4-config medium-2-config small-6-config
../venv/bin/python3 raw-op.py &
{ set +x; } 2> /dev/null

OP_PID="$!"

set -x
sleep 1
kubectl apply -f widgets.yaml
sleep 5
kubectl get configmaps large-4-config -o yaml
kubectl get configmaps medium-2-config -o yaml
kubectl get configmaps small-6-config -o yaml
kubectl delete -f widgets.yaml
kill -15 $OP_PID
sleep 1
kubectl delete -f widget-rd.yaml
kubectl delete --ignore-not-found configmaps large-4-config medium-2-config small-6-config
{ set +x; } 2> /dev/null
