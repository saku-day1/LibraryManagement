# LibraryManagement — Claude Code 作業ルール

> 詳細設計・API仕様・DB設計は [docs/detailed-design.md](docs/detailed-design.md) を参照。
> 機能要件は [docs/requirements.md](docs/requirements.md) を参照。

## ブランチ戦略

- **main への直接 push は禁止。** 必ず Pull Request 経由でマージすること。
- **新しい作業を始める前に必ず以下の順番で実施する:**
  1. GitHub Issue を作成する (`gh issue create`)
  2. Issue 番号を含むブランチを作成する (`git checkout -b feature/#<issue番号>-<説明>`)
  3. 作業完了後、PR を作成して main へマージする (`gh pr create`)
  4. PR 本文に `Closes #<issue番号>` を必ず記載する（マージ時に Issue が自動クローズされる）

### ブランチ命名規則

| 種別 | 形式 | 例 |
|------|------|----|
| 機能追加 | `feature/#<issue番号>-<説明>` | `feature/#4-kanban-board-ui` |
| バグ修正 | `fix/#<issue番号>-<説明>` | `fix/#5-book-status-update` |
| インフラ | `infra/#<issue番号>-<説明>` | `infra/#10-aws-ec2-deploy` |
| ドキュメント | `docs/#<issue番号>-<説明>` | `docs/#3-readme-update` |

## 確認コマンド (スキル)

新しい実装を始める前や PR 作成前に以下のカスタムコマンドで確認を行う。

| コマンド | 用途 | 実行タイミング |
|----------|------|----------------|
| `/review` | 要件定義・詳細設計・フェーズ完了条件との整合性を確認 | 各フェーズの実装完了後・PR 作成前 |
| `/security-check` | セキュリティ上の問題がないか確認 | PR 作成前 |
| `/cost-check` | 実装コストや依存関係の重さを確認 | 新規ライブラリ追加時・PR 作成前 |

## 技術スタック

| レイヤー | 技術 |
|----------|------|
| フロントエンド | Vue 3 + TypeScript (Vite 5) |
| バックエンド | Ruby on Rails 7 (API mode) |
| データベース | MySQL 8.0 |
| 開発環境 | Docker Compose |
| デプロイ | AWS EC2 + RDS |

## 実装フェーズ一覧

各フェーズの詳細手順（コマンド・作成ファイル・完了条件）は [docs/detailed-design.md#実装フェーズ詳細](docs/detailed-design.md) を参照。

| フェーズ | 概要 |
|----------|------|
| Phase 1 | Vue 3 + TypeScript プロジェクト作成・カンバンボード UI（モックデータ） |
| Phase 2 | ドラッグ&ドロップ・書籍登録モーダル・詳細編集 UI |
| Phase 3 | Rails API プロジェクト作成・DB マイグレーション・CRUD API 実装 |
| Phase 4 | フロントを API に接続・モックデータを削除 |
| Phase 5 | Docker Compose でローカル統合確認 |
| Phase 6 | AWS EC2 + RDS 環境構築・デプロイ |

### フェーズ開始時の標準手順

```bash
# 1. Issue 作成
gh issue create --title "Phase N: <フェーズ概要>" --body "<作業内容>"

# 2. ブランチ作成（Issue番号を確認してから）
git checkout main && git pull
git checkout -b feature/#<issue番号>-<説明>

# 3. 実装（詳細設計を参照）

# 4. PR 作成
gh pr create --title "Phase N: <タイトル>" --body "Closes #<issue番号>"
```
