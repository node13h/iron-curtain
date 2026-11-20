FROM dhi.io/python:3.15-dev@sha256:bf6e3ca018ffb2e5b1450f9a918965cc1bd239a30d4791d84d974fd4297d431d AS build-stage

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

RUN python -m venv /app/venv \
    && pip install --no-cache-dir --requirement /tmp/requirements.txt

FROM dhi.io/python:3.15@sha256:d90203ad5dd6c0d9fe58efd6347795375b3f5f2430be2bf61573510452f718e5 AS runtime-stage

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

COPY --from=build-stage /app/venv /app/venv
COPY --chmod=0755 docker-entrypoint.py /docker-entrypoint.py

VOLUME ["/data"]

EXPOSE 3141

ENTRYPOINT ["python3", "/docker-entrypoint.py"]

CMD []
