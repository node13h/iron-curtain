# AGENTS.md

Docker Compose stack that provides an isolated environment to start development containers
in: no Internet access, LLM traffic via agentgateway, package access via optional local
mirror repositories (devpi, verdaccio). Even the gateway and mirrors do not have direct
Internet access - their egress is via an allowlisting Envoy proxy. See `README.md`.

## Layout

- `docker-compose.yml` - the stack
- `agentgateway/`, `egress-proxy/` (Envoy), `docker-devpi/`, `verdaccio/` - per-service config
- `.devcontainer/` - dev container definition and local features

## Commands

- `make lint` (alias `make test`) - shellcheck, hadolint, compose config + dclint, yamllint
- `make reformat` - ruff (in `docker-devpi/`) and yq formatting of YAML files

Run `make lint` before finishing a change.

## Conventions

- Keep the security model intact: don't add Internet routes to the `agents` network or
  widen the egress allowlist without a clear reason.
- Never commit secrets or API keys.
