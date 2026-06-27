#/bin/bash

if [ ! -f .env ]; then
  echo ".envファイルが存在しません。"
  exit 1
fi

set -a
source .env
set +a

mkdir -p ${SSD_PATH}/traefik/config
mkdir -p ${HDD_PATH}/immich/data
mkdir -p ${SSD_PATH}/immich/db
mkdir -p ${SSD_PATH}/opencloud/config
mkdir -p ${SSD_PATH}/opencloud/data
mkdir -p ${SSD_PATH}/garage/meta
mkdir -p ${HDD_PATH}/garage/data

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
