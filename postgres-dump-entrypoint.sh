#!/usr/bin/env bash
set -euo pipefail

# execが使えないので、SIGTERMを受け取ったら、すべての子プロセスを終了して自分も終了する
trap 'kill -TERM -$pid' TERM


# postgresをエントリポイント経由で起動
/usr/local/bin/immich-docker-entrypoint.sh "$@" &
pid=$!

# 起動待ち
until /usr/local/bin/healthcheck.sh
do
    sleep 1
done

# ダンプ取得
pg_dump --clean --if-exists --dbname="$POSTGRES_DB" --username="$POSTGRES_USER" | gzip -f > /backups/server-side-immich-db-backup-$(date +"%Y%m%dT%H%M%S").sql.gz

# 180日以上前のバックアップを削除
find /backups -type f -name "server-side-immich-db-backup-*.sql.gz" -mtime +180 -delete

# ヘルスチェックで反応するフラグを立てる
touch /tmp/backup-done

# 修了するのをブロック
wait $pid
