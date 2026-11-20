#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1007
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

mkdir -p /opt/mermaid
cp "${SCRIPT_DIR%/}/package.json" "${SCRIPT_DIR%/}/package-lock.json" /opt/mermaid/
(
    cd /opt/mermaid
    npm ci
)

ln -s /opt/mermaid/node_modules/.bin/mmdc /usr/local/bin/mmdc
