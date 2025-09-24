#!/bin/bash
#
# https://github.com/awslabs/mountpoint-s3-csi-driver/blob/main/docs/CONFIGURATION.md
# (...)
# Warning: K8s secrets are not refreshed once read. To update long term credentials stored in K8s secrets, restart the CSI Driver pods.
# (...)
#
# apiVersion: v1
# kind: Secret
# metadata:
#   name: aws-secret
#   namespace: kube-system
# type: Opaque
# data:
#   key_id: ........  # AWS_ACCESS_KEY_ID: base64 encoded "AKIA..."
#   access_key: ........  # AWS_SECRET_ACCESS_KEY base64 encoded
#
# Config values:
#
#   https://github.com/awslabs/mountpoint-s3-csi-driver/blob/main/charts/aws-mountpoint-s3-csi-driver/values.yaml
#

# FIXME: define a more secure method (this is a temporary one)

cd "$(dirname "$0")"

[ "$SECRETS" = "" ] && SECRETS=".secrets"

[ -f "$SECRETS" ] && source "$SECRETS"

if [ "$AWS_ACCESS_KEY_ID" = "" ]
then
  echo "error: 'AWS_ACCESS_KEY_ID' undefined"
  exit 1
fi

if [ "$AWS_SECRET_ACCESS_KEY" = "" ]
then
  echo "error: 'AWS_SECRET_ACCESS_KEY' undefined"
  exit 1
fi

SECRET_NAME="aws-secret"
NS="kube-system"

set -x

kubectl -n $NS delete secret $SECRET_NAME

kubectl -n $NS \
  create secret generic $SECRET_NAME \
  --from-literal "key_id=${AWS_ACCESS_KEY_ID}" \
  --from-literal "access_key=${AWS_SECRET_ACCESS_KEY}"

#kubectl -n $NS get secret $SECRET_NAME
kubectl -n $NS get secret $SECRET_NAME -o jsonpath="{.data.key_id}" | base64 -d
kubectl -n $NS get secret $SECRET_NAME -o jsonpath="{.data.access_key}" | base64 -d

{ set +x; } 2>/dev/null

