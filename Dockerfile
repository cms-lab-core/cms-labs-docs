FROM docker.io/library/python:3.14.7-slim AS build

ARG ZENSICAL_VERSION=0.0.67
WORKDIR /src

RUN pip install --no-cache-dir "zensical==${ZENSICAL_VERSION}"

COPY zensical.toml ./
COPY docs ./docs

RUN zensical build --clean --strict

FROM docker.io/library/nginx:1.31.6-alpine3.24

RUN apk upgrade --no-cache \
    && rm -f /etc/nginx/conf.d/default.conf

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build --chown=nginx:nginx /src/site /usr/share/nginx/html

USER nginx
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
