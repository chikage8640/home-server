#/bin/bash

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo ".envファイルが存在しません。"
  exit 1
fi

set -a
source .env
set +a

mkdir -p ${SSD_PATH}/traefik/config/acme
mkdir -p ${HDD_PATH}/immich/data/backups
mkdir -p ${HDD_PATH}/immich/data/library
mkdir -p ${HDD_PATH}/immich/data/profile
mkdir -p ${HDD_PATH}/immich/data/upload
mkdir -p ${SSD_PATH}/immich/db
mkdir -p ${SSD_PATH}/opencloud/config
mkdir -p ${SSD_PATH}/opencloud/data
mkdir -p ${SSD_PATH}/garage/meta
mkdir -p ${HDD_PATH}/garage/data
mkdir -p ${SSD_PATH}/rclone/dump

touch ${SSD_PATH}/traefik/config/acme/acme.json
chmod 600 ${SSD_PATH}/traefik/config/acme/acme.json

cp ./csp.yaml ${SSD_PATH}/opencloud/config/csp.yaml

cat > ${SSD_PATH}/garage/garage.toml <<EOF
metadata_dir = "/var/lib/garage/meta"
data_dir = "/var/lib/garage/data"
db_engine = "sqlite"

replication_factor = 1

rpc_bind_addr = "[::]:3901"
rpc_public_addr = "127.0.0.1:3901"
rpc_secret = "$(openssl rand -hex 32)"

[s3_api]
s3_region = "garage"
api_bind_addr = "[::]:3900"
root_domain = ".s3.garage.localhost"

[s3_web]
bind_addr = "[::]:3902"
root_domain = ".web.garage.localhost"
index = "index.html"

[admin]
api_bind_addr = "[::]:3903"
admin_token = "$(openssl rand -base64 32)"
metrics_token = "$(openssl rand -base64 32)"
EOF

cat > /etc/systemd/system/home-server-resume.service <<EOF
[Unit]
Description=Resume backup task
ConditionPathExists=/var/lib/home-server/service-start-required

[Service]
Type=oneshot
ExecStart=$(pwd)/backup-and-update.sh --rebooted

[Install]
WantedBy=multi-user.target
EOF