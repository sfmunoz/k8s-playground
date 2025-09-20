#!/bin/bash

cd "$(dirname "$0")"

set -x
kubectl apply -f web-demo.yaml
{ set +x; } 2>/dev/null

