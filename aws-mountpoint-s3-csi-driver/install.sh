#!/bin/bash
#
# https://github.com/awslabs/mountpoint-s3-csi-driver/blob/main/docs/INSTALL.md
#

set -x
helm repo add aws-mountpoint-s3-csi-driver https://awslabs.github.io/mountpoint-s3-csi-driver
helm repo update

# I was unable to make the selector work so I'm removing this nodeSelector while using just one node
# old: --set controller.nodeSelector."kubernetes\.io/role"="control-plane"
# new: --set controller.nodeSelector."node-role\.kubernetes\.io/control-plane"=""
#      "" == "true" (it's redundant so it's omitted)

helm upgrade \
  --install aws-mountpoint-s3-csi-driver \
  --namespace kube-system \
  aws-mountpoint-s3-csi-driver/aws-mountpoint-s3-csi-driver
{ set +x; } 2>/dev/null
