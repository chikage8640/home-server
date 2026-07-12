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
pg_dump --clean --if-exists --dbname="$POSTGRES_DB" --username="$POSTGRES_USER" | gzip -f > /backup/dump.sql.gz

# ヘルスチェックで反応するフラグを立てる
touch /tmp/backup-done

# 修了するのをブロック
wait $pid
