#!/bin/bash

# Ref:
#   https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
#
# Dashboard URL: https://localhost:8443/

set -x
kubectl -n kubernetes-dashboard get svc -o wide
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
{ set +x; } 2>/dev/null

