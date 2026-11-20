.PHONY: lock

PIPCOMPILE ?= pip-compile

# Regenerate requirements.txt from requirements.in. Run after editing requirements.in.
# --no-emit-index-url keeps machine-specific index settings out of the lock file.
lock:
	$(PIPCOMPILE) --no-emit-index-url --output-file=requirements.txt requirements.in
