#!/bin/bash

set -x
kubectl -n kube-system delete secret aws-secret
{ set +x; } 2>/dev/null
