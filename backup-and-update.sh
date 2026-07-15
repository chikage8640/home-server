#!/usr/bin/env bash

cd $(dirname $0)

bash ./backup.sh
docker compose pull
docker compose up -d