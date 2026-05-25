# LibraryManagement — Claude Code 作業ルール

> 詳細設計・API仕様・DB設計は [docs/detailed-design.md](docs/detailed-design.md) を参照。
> 機能要件は [docs/requirements.md](docs/requirements.md) を参照。

## 絶対に守るルール

| ルール | 内容 |
|--------|------|
| **main への直接 push は絶対禁止** | いかなる場合も main へ直接 push してはならない。必ずブランチを切って PR を作成すること。判断に迷う場合はユーザーに確認する |
| **コミット&プッシュはユーザーの指示があった場合のみ** | 実装・編集が完了しても、ユーザーから「コミットして」「プッシュして」と指示されるまで `git commit` / `git push` を実行しない |
| **マージはユーザーが行う** | PR の作成まではエージェントが行うが、`gh pr merge` は実行しない。マージ操作はユーザーが GitHub 上で行う |

## 作業開始時の必須手順

新しい作業を始める前に **必ず** 以下の順番で実施する。

1. GitHub Issue を作成する (`gh issue create`)
2. main を最新化してからブランチを作成する
   ```bash
   git checkout main && git pull
   git checkout -b feature/#<issue番号>-<説明>
   ```
3. 実装・編集を行う（詳細設計を参照）
4. ユーザーから指示があった場合のみコミット&プッシュする
   ```bash
   git add <ファイル>
   git commit -m "メッセージ"
   git push -u origin <ブランチ名>
   ```
5. PR を作成する（マージはユーザーが行う）
   ```bash
   gh pr create --title "<タイトル>" --body "Closes #<issue番号>"
   ```

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
| `/start-frontend` | Vue 開発サーバーを起動（localhost:5173） | フロントエンド動作確認時 |
| `/start-backend` | Rails API + MySQL を Docker で起動（localhost:3000） | バックエンド動作確認時 |
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

責務分離の観点から Read → Create → Update → Delete の順で実装する。

| フェーズ | 層 | 責務 | 概要 |
|----------|----|------|------|
| Phase 1 | フロントエンド | Read | Vue プロジェクト作成・カンバンボード表示（モックデータ） |
| Phase 2 | フロントエンド | Create | 書籍登録モーダル |
| Phase 3 | フロントエンド | Update | D&D ステータス変更・編集モーダル |
| Phase 4 | フロントエンド | Delete | 削除ボタン・確認ダイアログ（フールプルーフ設計） |
| Phase 5 | バックエンド | Read | Rails プロジェクト作成・一覧・詳細 API |
| Phase 6 | バックエンド | Create | 書籍登録 API |
| Phase 7 | バックエンド | Update | 書籍更新 API |
| Phase 8 | バックエンド | Delete | 書籍削除 API |
| Phase 9 | 統合 | - | フロントエンドを API に接続・モックデータを削除 |
| Phase 10 | 統合 | - | Docker Compose でローカル統合確認 |
| Phase 11 | インフラ | - | AWS EC2 + RDS 環境構築・デプロイ |
