# LibraryManagement

書籍の読書ステータスを Trello ライクなカンバンボードで管理する Web アプリケーション。

## ドキュメント

| ドキュメント | 内容 |
|---|---|
| [要件定義](docs/requirements.md) | システム概要・機能要件・非機能要件 |
| [詳細設計](docs/detailed-design.md) | 技術スタック・DB設計・API設計・デプロイ構成・実装方針 |

## クイックスタート

```bash
# リポジトリのクローン
git clone https://github.com/saku-day1/LibraryManagement.git
cd LibraryManagement

# 起動（Docker が必要）
docker compose up
```

| サービス | URL |
|---|---|
| フロントエンド | http://localhost:5173 |
| バックエンド API | http://localhost:3000 |

## 作業ルール

新しい作業を始める前に必ず [CLAUDE.md](CLAUDE.md) を確認すること。
