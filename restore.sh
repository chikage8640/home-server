#!/usr/bin/env bash

cd "$(dirname "$0")"

bash ./initialize.sh && \
sudo docker compose -f restore-compose.yaml build --pull ; \
sudo docker compose -f restore-compose.yaml run --rm rclone-restore ;\
sudo docker compose -f restore-compose.yaml down