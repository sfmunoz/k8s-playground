#!/bin/bash
#
# https://github.com/awslabs/mountpoint-s3-csi-driver/blob/main/docs/INSTALL.md
#

set -x
helm repo add aws-mountpoint-s3-csi-driver https://awslabs.github.io/mountpoint-s3-csi-driver
helm repo update
helm upgrade \
  --install aws-mountpoint-s3-csi-driver \
  --namespace kube-system \
  --set controller.nodeSelector."kubernetes\.io/role"="control-plane" \
  aws-mountpoint-s3-csi-driver/aws-mountpoint-s3-csi-driver
{ set +x; } 2>/dev/null
