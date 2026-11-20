#!/usr/bin/env bash

set -euxo pipefail

# Feature option values are exposed as upper-cased environment variables.
HADOLINT_VERSION="${HADOLINTVERSION:?}"

ARCH=$(arch)
case "$ARCH" in
    aarch64)
        HADOLINT_ARCH=arm64
        SHA256="${SHA256ARM64:?}"
        ;;
    x86_64)
        HADOLINT_ARCH=x86_64
        SHA256="${SHA256AMD64:?}"
        ;;
    *)
        printf 'Unsupported architecture %s\n' "$ARCH" >&2
        exit 1
        ;;
esac

curl -Lfs "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-linux-${HADOLINT_ARCH}" -o /tmp/hadolint
echo "${SHA256}  /tmp/hadolint" | sha256sum --check --strict -
install -m 0755 /tmp/hadolint /usr/local/bin/hadolint
rm /tmp/hadolint
