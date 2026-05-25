# LibraryManagement — Claude Code 作業ルール

## ブランチ戦略

- **main への直接 push は禁止。** 必ず Pull Request 経由でマージすること。
- **新しい作業を始める前に必ず以下の順番で実施する:**
  1. GitHub Issue を作成する (`gh issue create`)
  2. Issue 番号を含むブランチを作成する (`git checkout -b feature/#<issue番号>-<説明>`)
  3. 作業完了後、PR を作成して main へマージする (`gh pr create`)

### ブランチ命名規則

| 種別 | 形式 | 例 |
|------|------|----|
| 機能追加 | `feature/#<issue番号>-<説明>` | `feature/#1-rails-api-setup` |
| バグ修正 | `fix/#<issue番号>-<説明>` | `fix/#5-book-status-update` |
| インフラ | `infra/#<issue番号>-<説明>` | `infra/#10-aws-ec2-deploy` |
| ドキュメント | `docs/#<issue番号>-<説明>` | `docs/#3-readme-update` |

## 確認コマンド (スキル)

新しい実装を始める前や PR 作成前に以下のカスタムコマンドで確認を行う。

| コマンド | 用途 |
|----------|------|
| `/security-check` | セキュリティ上の問題がないか確認 |
| `/cost-check` | 実装コストや依存関係の重さを確認 |

## 技術スタック

- フロントエンド: Vue 3 + TypeScript (Vite)
- バックエンド: Ruby on Rails 7 (API mode)
- データベース: MySQL 8.0
- デプロイ: AWS EC2 + RDS
