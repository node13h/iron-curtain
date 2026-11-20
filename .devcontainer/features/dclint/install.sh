#!/usr/bin/env bash

set -euxo pipefail

# Feature option values are exposed as upper-cased environment variables.
DCLINT_VERSION="${DCLINTVERSION:?}"

ARCH=$(arch)
case "$ARCH" in
    aarch64)
        DCLINT_ARCH=arm64
        SHA256="${SHA256ARM64:?}"
        ;;
    x86_64)
        DCLINT_ARCH=amd64
        SHA256="${SHA256AMD64:?}"
        ;;
    *)
        printf 'Unsupported architecture %s\n' "$ARCH" >&2
        exit 1
        ;;
esac

curl -Lfs "https://github.com/zavoloklom/docker-compose-linter/releases/download/v${DCLINT_VERSION}/dclint-bullseye-${DCLINT_ARCH}" -o /tmp/dclint
echo "${SHA256}  /tmp/dclint" | sha256sum --check --strict -
install -m 0755 /tmp/dclint /usr/local/bin/dclint
rm /tmp/dclint
