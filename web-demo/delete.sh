#!/bin/bash

cd "$(dirname "$0")"

set -x
kubectl delete -f web-demo.yaml
{ set +x; } 2>/dev/null

