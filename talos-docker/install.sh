#!/bin/bash

[[ "${WORKERS}" = "" ]] && WORKERS=2

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /usr/bin/env NONINTERACTIVE=1 /bin/bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew tap siderolabs/tap
brew trust siderolabs/tap
brew install siderolabs/tap/talosctl kubernetes-cli

talosctl cluster create docker \
  --workers $WORKERS

cat > /home/vagrant/.bashrc << __EOF
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(talosctl completion bash)
__EOF
