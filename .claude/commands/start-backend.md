Rails API と MySQL を Docker Compose で起動してください。

## 手順

1. `backend/` ディレクトリと `docker-compose.yml` が存在するか確認する
   - 存在しない場合は「Phase 5 がまだ実装されていません」と伝えて終了する
2. Docker が起動しているか確認する
   - 起動していない場合は「Docker Desktop を起動してください」と伝えて終了する
3. 以下のコマンドでバックエンドと DB を起動する

```bash
docker compose up backend db
```

バックグラウンドで起動したい場合:

```bash
docker compose up backend db -d
```

## 起動後に確認すること

- `http://localhost:3000/api/v1/books` にアクセスして `[]` が返ることを確認する
- エラーが出た場合は `docker compose logs backend` でログを確認して原因を伝える
