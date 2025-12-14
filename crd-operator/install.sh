#!/bin/bash

set -e -o pipefail

cd "$(dirname "$0")"

if [ -d venv ]
then
  echo "venv already exists"
else
  set -x
  python3 -m virtualenv venv
  ./venv/bin/pip3 install kopf kubernetes
  { set +x; } 2> /dev/null
fi
