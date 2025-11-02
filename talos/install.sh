#!/bin/bash

set -e -o pipefail

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /usr/bin/env NONINTERACTIVE=1 /bin/bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install siderolabs/tap/talosctl kubernetes-cli
talosctl cluster create

cat > /home/vagrant/.bashrc << __EOF
eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(talosctl completion bash)
__EOF
