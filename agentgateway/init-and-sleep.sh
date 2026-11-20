#!/usr/bin/env sh

set -eu

get_if_ip () {
    ip -4 addr show dev "$1" | awk '/inet / {split($2, a, "/"); print a[1]}'
}

rm -f /tmp/ready

# Assuming busybox ip
WEB_UI_IF_IP=$(get_if_ip "$WEB_UI_IF")

if [ "$EXPOSE_API_ON_ALL_INTERFACES" -eq 1 ]; then
    API_IF_IP=0.0.0.0
else
    API_IF_IP=$(get_if_ip "$API_IF")
fi

export WEB_UI_IF_IP
export API_IF_IP

if ! [ -e /config/config.yaml ]; then
    cp /default-config.yaml /config/config.yaml
fi

yq -i '.gateways.web_ui.bindAddress = strenv(WEB_UI_IF_IP) | .gateways.api.bindAddress = strenv(API_IF_IP)' \
   /config/config.yaml

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    yq -i '(.llm.models[] | select(.name == "anthropic/*") | .params.apiKey) = strenv(ANTHROPIC_API_KEY)' /config/config.yaml
fi

if [ -n "${OMLX_API_KEY:-}" ]; then
    yq -i '(.llm.models[] | select(.name == "omlx/*") | .params.apiKey) = strenv(OMLX_API_KEY)' /config/config.yaml
fi

chown -R "${AG_UID}:${AG_GID}" /data
chown -R "${AG_UID}:${AG_GID}" /config

touch /tmp/ready

exec sleep infinity
