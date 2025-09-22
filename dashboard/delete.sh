#!/bin/bash

set -x
kubectl delete namespaces kubernetes-dashboard
{ set +x; } 2>/dev/null

