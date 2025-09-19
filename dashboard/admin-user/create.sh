#!/bin/bash

# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/ →
# → https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

# Token creation not needed
#kubectl -n kubernetes-dashboard create token admin-user

set -x
kubectl get clusterrole -A | awk '/^(NAME|cluster-admin)/'
kubectl describe clusterrole cluster-admin
cd "$(dirname "$0")"
kubectl apply -f admin-user.yaml
kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 -d
{ set +x; } 2>/dev/null

