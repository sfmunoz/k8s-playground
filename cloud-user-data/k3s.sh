#!/bin/bash
#
# Ref: https://k3s.io/
#
# https://my.vultr.com/ -> Orchestration -> Scripts
#   - Script Name ...... k3s
#   - Type ............. Boot
#   - Script ........... this file
#
# Server ref:
#   - Shared CPU ....... vc2-1c-2gb
#   - Cores ............ 1 vCPU
#   - Memory ........... 2 GB
#   - Storage .......... 55 GB
#   - Price ............ $10.00/month ($0.014/hr)
#   - OS ............... Debian 13 x64
#   - Startup Script ... k3s
#
# Output:
#   - /var/log/cloud-init-output.log
#   - /var/log/cloud-init.log
#

set -x
set -e
apt update
apt install -y tmux htop
curl -sfL https://get.k3s.io | bash -
ufw allow 6443/tcp
