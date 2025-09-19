#!/bin/bash

# Ref:
#   https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

set -x
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
{ set +x; } 2>/dev/null

