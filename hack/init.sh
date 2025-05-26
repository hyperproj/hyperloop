#!/bin/bash

set -e

GO_VERSION="1.24.3"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64 | arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

GO_FILENAME="go${GO_VERSION}.${OS}-${ARCH}.tar.gz"
GO_URL="https://go.dev/dl/${GO_FILENAME}"

echo "[INFO] Downloading Go from: $GO_URL"
curl -LO "$GO_URL"

echo "[INFO] Extracting Go to /usr/local..."
sudo tar -C /usr/local -xzf "$GO_FILENAME"

echo "[INFO] Configuring environment variables..."
{
  echo 'export PATH=$PATH:/usr/local/go/bin'
  echo 'export GOPATH=$HOME/go'
  echo 'export GOPROXY=https://goproxy.cn,direct'
  echo 'export PATH=$PATH:$GOPATH/bin'
} >> ~/.bashrc

mkdir -p "$HOME/go"


sudo apt-get update
sudo apt-get install -y gnupg make
curl -L https://packagecloud.io/fdio/2502/gpgkey | sudo apt-key add -
echo 'deb https://packagecloud.io/fdio/2502/ubuntu jammy main' | sudo tee /etc/apt/sources.list.d/99fdio.list
sudo apt-get update
sudo apt-get install -y vpp vpp-plugin-core vpp-dbg vpp-dev vpp-plugin-dpdk
sudo apt-get clean -y
