#!/usr/bin/env bash

# Installs the Python developer tools into a single /opt/pytools virtualenv
# and links their executables into /usr/local/bin.

set -euo pipefail

# shellcheck disable=SC1007
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

VENV=/opt/pytools
TOOLS=(poetry pytest mypy pip-compile pip-sync ruff uv)

python3 -m venv "$VENV"
"$VENV/bin/pip" install --no-cache-dir -r "${SCRIPT_DIR%/}/requirements.txt"

for tool in "${TOOLS[@]}"; do
    ln -s "$VENV/bin/$tool" "/usr/local/bin/$tool"
done
