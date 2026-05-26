# LibraryManagement

書籍の読書ステータスを Trello ライクなカンバンボードで管理する Web アプリケーション。

![Rails](https://img.shields.io/badge/Rails-8.1-cc0000?logo=rubyonrails)
![Vue](https://img.shields.io/badge/Vue-3.x-42b883?logo=vuedotjs)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178c6?logo=typescript)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479a1?logo=mysql)
![AWS](https://img.shields.io/badge/AWS-EC2+RDS-ff9900?logo=amazonaws)
![CI](https://github.com/saku-day1/LibraryManagement/actions/workflows/ci.yml/badge.svg)

---

## ドキュメント

| ドキュメント | 内容 |
|---|---|
| [要件定義](docs/requirements.md) | システム概要・機能要件・非機能要件 |
| [詳細設計](docs/detailed-design.md) | 技術スタック・DB設計・API設計・デプロイ構成・実装方針 |

---

## 機能

- **カンバンボード**: 未読 / 読書中 / 読了 の3カラム表示
- **ドラッグ&ドロップ**: カードを移動してステータスを即時更新
- **書籍登録・編集**: タイトル・著者・ISBN・評価・感想メモ・読み始め日・読了日
- **削除確認ダイアログ**: 誤操作防止のフールプルーフ設計
- **検索・フィルター**: タイトル・著者のキーワード検索とステータス絞り込み
- **エラートースト**: API 通信失敗時のユーザーフィードバック

---

## 技術スタック

| レイヤー | 技術 |
|---|---|
| フロントエンド | Vue 3 + TypeScript (Vite 5) |
| バックエンド | Ruby on Rails 8 (API mode) |
| データベース | MySQL 8.0 |
| 開発環境 | Docker Compose |
| インフラ | AWS EC2 (t2.micro) + RDS (db.t3.micro) + Nginx + Puma |
| IaC | Terraform |
| CI | GitHub Actions |

---

## クイックスタート（ローカル）

```bash
git clone https://github.com/saku-day1/LibraryManagement.git
cd LibraryManagement
docker compose up
```

| サービス | URL |
|---|---|
| フロントエンド | http://localhost:5173 |
| バックエンド API | http://localhost:3000/api/v1/books |

---

## 実装フェーズ

本プロジェクトは責務分離の観点から **Read → Create → Update → Delete** の順で 11 フェーズに分けて実装した。

| フェーズ | 層 | 内容 |
|---|---|---|
| Phase 1 | フロントエンド | Vue プロジェクト作成・カンバンボード表示（モックデータ） |
| Phase 2 | フロントエンド | 書籍登録モーダル |
| Phase 3 | フロントエンド | D&D ステータス変更・編集モーダル |
| Phase 4 | フロントエンド | 削除ボタン・確認ダイアログ |
| Phase 5 | バックエンド | Rails プロジェクト作成・一覧・詳細 API |
| Phase 6 | バックエンド | 書籍登録 API |
| Phase 7 | バックエンド | 書籍更新 API |
| Phase 8 | バックエンド | 書籍削除 API |
| Phase 9 | 統合 | フロントエンドを Rails API に接続 |
| Phase 10 | 統合 | Docker Compose でローカル統合確認 |
| Phase 11 | インフラ | AWS EC2 + RDS 環境構築・Terraform デプロイ |

---

## AWS デプロイ構成

```
ユーザー
  │ HTTP :80
  ▼
Nginx (EC2 t2.micro)
  ├─ /api/* ──► Puma / Rails API :3000
  └─ その他 ──► Vue dist/ (静的ファイル)
                         │
                    RDS db.t3.micro
                    MySQL 8.0
```

- EC2 セキュリティグループ: HTTP(80) / SSH(22・自分の IP のみ)
- RDS セキュリティグループ: EC2 からの MySQL(3306) のみ許可
- 環境変数: EC2 上の `.env.production` で管理（Git 管理外）
- IaC: `terraform/` 配下で EC2・RDS・セキュリティグループを定義

---

## CI

GitHub Actions で `push` / `pull_request` 時に自動実行。

| ジョブ | 内容 |
|---|---|
| Rails Test | MySQL 8.0 コンテナを起動し `rails test` を実行（18 ケース） |
| Frontend Build | `npm ci && npm run build` でビルドエラーを検出 |

---

## AI 活用ポイント

本プロジェクトは **Claude Code (Anthropic)** を活用して要件定義からデプロイまでを実施した。

| フェーズ | AI の活用内容 |
|---|---|
| 要件定義・設計 | 機能要件・非機能要件の整理、ER 図・API 設計・画面設計の作成 |
| 実装 | Vue / Rails の各フェーズの実装、型定義・バリデーション設計 |
| コードレビュー | `/code-review` カスタムスキルによる6観点（要件逸脱・責務分離・保守性・セキュリティ・運用性・テスト）での自動レビュー |
| テスト | Minitest によるモデル・コントローラーテストの設計と実装 |
| インフラ | Terraform による AWS 構成の設計、EC2 セットアップスクリプトの作成 |
| CI/CD | GitHub Actions ワークフローの設計・デバッグ |
| 品質改善 | レビュー指摘の修正、コスト最適化、セキュリティ改善 |

---

## 残課題

| 項目 | 理由 |
|---|---|
| HTTPS 対応 | ACM + ALB が必要。課題スコープ外として未対応 |
| フロントエンドテスト | Vitest + Vue Test Utils での実装が今後の課題 |
