#!/bin/bash
#
# https://github.com/awslabs/mountpoint-s3-csi-driver/blob/main/docs/INSTALL.md
#

set -x
helm uninstall aws-mountpoint-s3-csi-driver --namespace kube-system
{ set +x; } 2>/dev/null
