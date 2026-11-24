#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1007
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

mkdir -p /opt/pi/extensions
cp "${SCRIPT_DIR%/}/package.json" "${SCRIPT_DIR%/}/package-lock.json" /opt/pi/
cp "${SCRIPT_DIR%/}/env.ts" "${SCRIPT_DIR%/}/anthropic.ts" /opt/pi/extensions/
(
    cd /opt/pi
    npm ci --ignore-scripts
)

ln -s /opt/pi/node_modules/.bin/pi /usr/local/bin/pi

# Auto-load the extension for the remote user (global pi extensions directory).
USER_NAME="${_REMOTE_USER:-root}"
USER_HOME="${_REMOTE_USER_HOME:-$(getent passwd "${USER_NAME}" | cut -d: -f6)}"
mkdir -p "${USER_HOME}/.pi/agent/extensions"
ln -sf /opt/pi/extensions/env.ts "${USER_HOME}/.pi/agent/extensions/env.ts"
ln -sf /opt/pi/extensions/anthropic.ts "${USER_HOME}/.pi/agent/extensions/anthropic.ts"
chown -R "${USER_NAME}:" "${USER_HOME}/.pi"
