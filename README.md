# セットアップ方法

1. `.env`かきかき
2. `rclone/config/rclone.conf`かきかき
3. `initialize.sh`

# レストア

1. `.env`かきかき
2. `rclone/config/rclone.conf`かきかき
3. `docker compose -f restore-compose.yaml up -d rclone-restore-request`
4. `restore.sh`