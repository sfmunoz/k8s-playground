#!/bin/bash

# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/ →
# → https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

set -x
kubectl -n kubernetes-dashboard delete serviceaccount admin-user
kubectl -n kubernetes-dashboard delete clusterrolebinding admin-user
{ set +x; } 2>/dev/null

