フロントエンド（Vue 3）とバックエンド（Rails API + MySQL）を起動してください。

## 手順

1. 前提確認（Bash の `ls` または `Test-Path` でディレクトリの存在を確認すること。Glob ツールはディレクトリ名にマッチしないため使用禁止）
   - `frontend/` がない場合: 「Phase 1 がまだ実装されていません」と伝えて終了

```bash
# 確認コマンド例
ls frontend 2>&1
```

2. バックエンドの起動（`backend/` と `docker-compose.yml` が両方存在する場合のみ）
   - Docker が起動していない場合: 「Docker Desktop を起動してください」と伝えて終了
   - 存在する場合は以下を実行する

```bash
docker compose up backend db -d
```

   - `backend/` または `docker-compose.yml` がない場合はこのステップをスキップし、「バックエンドは Phase 5 未実装のためスキップします」と伝える

3. フロントエンドの依存パッケージが未インストールの場合（`frontend/node_modules/` がない）は先に実行する

```bash
cd frontend && npm install
```

4. フロントエンドの開発サーバーを起動する

```bash
cd frontend && npm run dev
```

## 起動後に確認すること

- フロントエンドは Vite が出力する URL を案内する（デフォルト `http://localhost:5173`、使用中なら自動で別ポートに変わる）
- バックエンドを起動した場合は `http://localhost:3000/api/v1/books` で確認できることを伝える
- バックエンドのエラーは `docker compose logs backend` で確認できることを伝える
- **必ず起動した全サービスの URL をユーザーに明示して案内する**
