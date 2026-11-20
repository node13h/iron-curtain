#!/usr/bin/env bash

set -euxo pipefail

# Feature option values are exposed as upper-cased environment variables.
YQ_VERSION="${YQVERSION:?}"

ARCH=$(arch)
case "$ARCH" in
    aarch64)
        YQ_ARCH=arm64
        SHA256="${SHA256ARM64:?}"
        ;;
    x86_64)
        YQ_ARCH=amd64
        SHA256="${SHA256AMD64:?}"
        ;;
    *)
        printf 'Unsupported architecture %s\n' "$ARCH" >&2
        exit 1
        ;;
esac

curl -Lfs "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${YQ_ARCH}" -o /tmp/yq
echo "${SHA256}  /tmp/yq" | sha256sum --check --strict -
install -m 0755 /tmp/yq /usr/local/bin/yq
rm /tmp/yq
