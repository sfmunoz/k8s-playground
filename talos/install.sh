#!/bin/bash

[[ "${CONTROLPLANES}" = "" ]] && CONTROLPLANES=2
[[ "${WORKERS}" = "" ]] && WORKERS=2

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /usr/bin/env NONINTERACTIVE=1 /bin/bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install siderolabs/tap/talosctl kubernetes-cli

talosctl cluster create \
  --controlplanes $CONTROLPLANES \
  --workers $WORKERS

cat > /home/vagrant/.bashrc << __EOF
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(talosctl completion bash)
__EOF
