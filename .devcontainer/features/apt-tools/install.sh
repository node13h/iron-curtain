#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends yamllint bash make shellcheck ripgrep curl ca-certificates python3 python3-venv
rm -rf /var/lib/apt/lists/*
