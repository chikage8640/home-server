#!/usr/bin/env bash

cd $(dirname $0)

docker compose down && \
docker compose -f backup-compose.yaml build --pull ; \
docker compose -f backup-compose.yaml run --rm rclone-backup ;\
docker compose -f backup-compose.yaml down