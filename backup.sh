#!/usr/bin/env bash

cd $(dirname $0)

bash ./initialize.sh && \
sudo docker compose -f backup-compose.yaml build --pull ; \
sudo docker compose -f backup-compose.yaml run --rm rclone-backup ;\
sudo docker compose -f backup-compose.yaml down