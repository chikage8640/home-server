#!/usr/bin/env bash

cd "$(dirname "$0")"

SERVICE_START_REQUIRED_FILE_PATH="/var/lib/home-server/service-start-required"

# 引数に --rebooted が指定されているときは、再起動後の処理を行う
if [ "$1" == "--rebooted" ]; then
  docker compose up -d
  rm -f "$SERVICE_START_REQUIRED_FILE_PATH"
  exit 0
fi

bash ./backup.sh
docker compose pull

GEOBLOCK_TAG="$(curl --fail --silent --show-error --location \
        -H 'Accept: application/vnd.github+json' \
        https://api.github.com/repos/david-garcia-garcia/traefik-geoblock/releases/latest \
        | jq --exit-status --raw-output '.tag_name')"


GEOBLOCK_VERSION="$GEOBLOCK_TAG" docker compose build --pull

# unattended-upgrades が再起動の必要なアップデートをインストールしている場合には、フラグを付けて再起動
if [ -f /var/run/reboot-required ]; then
  touch "$SERVICE_START_REQUIRED_FILE_PATH"
  shutdown -r now
else
  docker compose up -d
fi
