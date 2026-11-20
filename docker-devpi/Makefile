.PHONY: lock

PIPCOMPILE ?= pip-compile

# Regenerate requirements.txt from requirements.in. Run after editing requirements.in.
# --no-emit-index-url keeps machine-specific index settings out of the lock file.
# --allow-unsafe pins setuptools, which pyramid needs at runtime.
lock:
	$(PIPCOMPILE) --allow-unsafe --no-emit-index-url --output-file=requirements.txt requirements.in
