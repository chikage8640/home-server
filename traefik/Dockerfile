FROM alpine:latest AS geoblock-source

ARG GEOBLOCK_VERSION

RUN apk add --no-cache curl git jq

RUN if [ -n "${GEOBLOCK_VERSION}" ]; then \
      latest_tag="${GEOBLOCK_VERSION}"; \
    else \
      latest_tag="$(curl --fail --silent --show-error --location \
        -H 'Accept: application/vnd.github+json' \
        https://api.github.com/repos/david-garcia-garcia/traefik-geoblock/releases/latest \
        | jq --exit-status --raw-output '.tag_name')"; \
    fi \
    && git clone --depth 1 --branch "${latest_tag}" \
    https://github.com/david-garcia-garcia/traefik-geoblock.git \
    /src/traefik-geoblock

FROM traefik:latest

COPY --from=geoblock-source /src/traefik-geoblock \
    /plugins-local/src/github.com/david-garcia-garcia/traefik-geoblock
