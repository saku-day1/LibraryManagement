# 詳細設計

## 技術スタック

| レイヤー | 技術 | バージョン |
|---|---|---|
| フロントエンド | Vue 3 + TypeScript (Vite) | Vue 3.x / Vite 5.x |
| バックエンド | Ruby on Rails (API mode) | Rails 7.x / Ruby 3.3 |
| データベース | MySQL | 8.0 |
| インフラ（本番） | AWS EC2 + RDS | t3.micro / db.t3.micro |
| 開発環境 | Docker Compose | - |

## ディレクトリ構成

```
LibraryManagement/
├── frontend/                   # Vue 3 + TypeScript
│   ├── src/
│   │   ├── components/
│   │   │   ├── KanbanBoard.vue
│   │   │   ├── KanbanColumn.vue
│   │   │   ├── BookCard.vue
│   │   │   └── BookModal.vue
│   │   ├── api/
│   │   │   └── books.ts        # API 呼び出し関数
│   │   ├── types/
│   │   │   └── book.ts         # Book 型定義
│   │   └── App.vue
│   ├── Dockerfile
│   └── package.json
├── backend/                    # Ruby on Rails API
│   ├── app/
│   │   ├── controllers/api/v1/books_controller.rb
│   │   ├── models/book.rb
│   │   └── serializers/book_serializer.rb
│   ├── config/routes.rb
│   ├── db/migrate/
│   ├── Dockerfile
│   └── Gemfile
├── docs/
│   ├── requirements.md         # 要件定義
│   └── detailed-design.md      # 本ドキュメント
├── docker-compose.yml
├── CLAUDE.md
└── README.md
```

## データベース設計

### books テーブル

| カラム | 型 | 制約 |
|---|---|---|
| id | bigint | PK, AUTO_INCREMENT |
| title | varchar(255) | NOT NULL |
| author | varchar(100) | NOT NULL |
| status | enum | NOT NULL, DEFAULT 'unread' |
| isbn | varchar(13) | NULLABLE |
| cover_image_url | text | NULLABLE |
| rating | tinyint | NULLABLE（1〜5） |
| memo | text | NULLABLE |
| started_at | date | NULLABLE |
| completed_at | date | NULLABLE |
| created_at | datetime | NOT NULL |
| updated_at | datetime | NOT NULL |

status の enum 値: `unread` / `reading` / `completed`

## API 設計

Base URL: `/api/v1`

| Method | Path | 説明 |
|---|---|---|
| GET | /books | 全書籍取得（`?status=unread` でフィルタ可） |
| POST | /books | 書籍新規登録 |
| GET | /books/:id | 書籍詳細取得 |
| PATCH | /books/:id | 書籍更新（ステータス変更含む） |
| DELETE | /books/:id | 書籍削除 |

### レスポンス例（GET /books）

```json
[
  {
    "id": 1,
    "title": "リーダブルコード",
    "author": "Dustin Boswell",
    "status": "reading",
    "isbn": "9784873115658",
    "cover_image_url": null,
    "rating": null,
    "memo": null,
    "started_at": "2026-05-01",
    "completed_at": null,
    "created_at": "2026-05-25T00:00:00.000Z"
  }
]
```

## Docker 構成

```yaml
# docker-compose.yml（概要）
services:
  frontend:   # Vue 3 + Vite → localhost:5173
  backend:    # Rails API    → localhost:3000
  db:         # MySQL 8.0    → localhost:3306（db_data ボリュームで永続化）
```

- フロントエンドはローカルの Node.js（v24）で直接起動も可能
- Ruby / Rails はローカルインストール不要（Docker コンテナ内で動作）
- `docker compose down` でコンテナ停止、`-v` オプションで DB データも削除

## AWS デプロイ構成

```
[ユーザー] → [EC2 t3.micro]
               ├── Nginx（リバースプロキシ・Vue の dist/ 配信）
               └── Puma（Rails API サーバー）
                        ↓
            [RDS db.t3.micro (MySQL 8.0)]
```

- EC2: Amazon Linux 2023
- RDS: プライベートサブネット、EC2 からの 3306 ポートのみ許可
- 環境変数: EC2 の `.env` で DB 接続情報を管理（git 管理外）

## 実装フェーズ

| フェーズ | 内容 |
|---|---|
| Phase 1 | Vue 3 + TypeScript プロジェクト作成・カンバンボード UI（モックデータ） |
| Phase 2 | ドラッグ&ドロップ・書籍登録モーダル・詳細編集 UI |
| Phase 3 | Rails API プロジェクト作成・DB マイグレーション・CRUD API 実装 |
| Phase 4 | フロントを API に接続・モックデータを削除 |
| Phase 5 | Docker Compose でローカル統合確認 |
| Phase 6 | AWS EC2 + RDS 環境構築・デプロイ |
