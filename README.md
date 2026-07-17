# セットアップ方法

1. `.env`かきかき
2. `rclone/config/rclone.conf`かきかき
3. `initialize.sh`
4. https://github.com/chikage8640/home-server-wireguardを適当な固定IP持ったサーバー（フロントと呼ぶ）にクローンして動かす
5. フロント側の`wireguard/peer_home/peer_home.conf`を、`[Interface]`に`MTU = 1380`、`[Peer]`に`PersistentKeepalive = 25`を追記して`wireguard/config/wg_confs/home.conf`へ保存

# レストア

1. セットアップ方法の2まで進める
2. `docker compose -f restore-compose.yaml up -d rclone-restore-request`
3. `restore.sh`
4. セットアップ方法の4から進める