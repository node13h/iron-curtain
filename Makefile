.PHONY: test reformat lint lint-shell lint-dockerfile lint-compose lint-yaml

COMPOSE ?= docker compose
# '*' enables every profile so profile-gated services (e.g. devpi) are validated too.
COMPOSE_LINT = $(COMPOSE) --profile '*'

DOCKERFILES := $(shell find . -path ./.git -prune -o -type f \( -name Dockerfile -o -name 'Dockerfile.*' -o -name '*.Dockerfile' \) -print)
COMPOSE_FILES := docker-compose.yml

test: lint

reformat:
	cd docker-devpi && ruff check --select I --fix && ruff format
	find . -type f \( -name "*.yml" -o -name "*.yaml" \) -exec yq eval -i . {} \;

lint: lint-shell lint-dockerfile lint-compose lint-yaml

# '+' (not '\;') so a shellcheck failure propagates to make.
lint-shell:
	find . -path ./.git -prune -o -type f -name '*.sh' -exec shellcheck {} +

lint-dockerfile:
	hadolint $(DOCKERFILES)

# 'config' validates against the Compose spec; --no-interpolate avoids needing secrets in the env.
lint-compose:
	$(COMPOSE_LINT) $(addprefix -f ,$(COMPOSE_FILES)) config --quiet --no-interpolate
	dclint $(COMPOSE_FILES)

lint-yaml:
	find . -type f \( -name "*.yml" -o -name "*.yaml" \) -exec yamllint {} +
