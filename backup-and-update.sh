#!/usr/bin/env bash

cd $(dirname $0)

docker compose down
bash ./backup.sh
docker compose pull
docker compose up -d