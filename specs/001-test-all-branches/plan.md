# 実装計画: Enable tests on all branches (GitHub Actions)

**ブランチ**: `001-test-all-branches` | **日付**: 2026-02-15 | **仕様書**: `/specs/001-test-all-branches/spec.md`
**入力**: `/specs/001-test-all-branches/spec.md` の機能仕様書

**注記**: このテンプレートは `/speckit.plan` コマンドによって記入されます。実行フローについては `.specify/templates/commands/plan.md` を参照してください。

## 概要

`master` ブランチのみで実行されていた GitHub Actions ワークフロー (`deploy.yml`) を変更し、すべてのブランチでテスト (`build` ジョブ) が実行されるようにします。デプロイ (`deploy` ジョブ) は引き続き `master` ブランチへのプッシュ時のみ実行されるように制限します。

## 技術的コンテキスト

<!--
  アクションが必要: このセクションの内容を、プロジェクトの技術的詳細で
  置き換えてください。ここでの構造は、イテレーションプロセスをガイド
  するための参考として提示されています。
-->

**Language/Version (言語/バージョン)**: YAML (GitHub Actions Workflow)  
**Primary Dependencies (主要な依存関係)**: GitHub Actions, Docker Compose  
**Storage (ストレージ)**: N/A  
**Testing (テスト)**: RSpec (Dockerコンテナ内で実行)  
**Target Platform (ターゲットプラットフォーム)**: GitHub Actions  
**Project Type (プロジェクトタイプ)**: CI/CD Configuration  
**Performance Targets (パフォーマンス目標)**: N/A  
**Constraints (制約事項)**: `deploy` ジョブは `master` ブランチでのみ実行されること。  
**Scale/Scope (規模/スコープ)**: 単一のワークフローファイルの変更。

## 憲法チェック (Constitution Check)

*ゲート: フェーズ0のリサーチ前に通過必須。フェーズ1の設計後に再チェック。*

- [x] **Rails First & Standard Idioms**: CI設定のため直接の影響なし。
- [x] **Dockerized Environment**: `deploy.yml` は既に `docker compose` を使用してテストを実行しているため準拠。
- [x] **Test Driven & Focused**: 本機能はテスト実行頻度を向上させるものであり、原則に強く合致する。
- [x] **Simplicity & Readability**: 単一ファイル (`deploy.yml`) 内での条件分岐で実現し、構成を単純に保つ。
- [x] **Japanese Language Output**: ドキュメントは日本語で記述されている。

## プロジェクト構造

### ドキュメント (本機能用)

```text
specs/001-test-all-branches/
├── plan.md              # このファイル (/speckit.plan コマンドの出力)
├── research.md          # フェーズ0の出力 (/speckit.plan コマンド)
├── data-model.md        # フェーズ1の出力 (/speckit.plan コマンド)
├── quickstart.md        # フェーズ1の出力 (/speckit.plan コマンド)
├── contracts/           # フェーズ1の出力 (/speckit.plan コマンド)
└── tasks.md             # フェーズ2の出力 (/speckit.tasks コマンド - /speckit.plan では作成されない)
```

### ソースコード (リポジトリルート)
<!--
  アクションが必要: 以下のプレースホルダーツリーを、この機能の具体的なレイアウトで
  置き換えてください。未使用のオプションを削除し、選択した構造を
  実際のパス（例: apps/admin, packages/something）に展開してください。
  提出される計画にはオプションのラベルを含めないでください。
-->

```text
.github/
└── workflows/
    └── deploy.yml
```

**構造決定**: 既存の `.github/workflows/deploy.yml` を修正するのみ。

## 複雑性の追跡 (Complexity Tracking)

> **憲法チェックに違反があり、正当化が必要な場合のみ記入**

| 違反 | 必要理由 | より単純な代替案が却下された理由 |
| --- | --- | --- |
| なし | - | - |
|-----------|------------|-------------------------------------|
| [例: 第4のプロジェクト] | [現在の必要性] | [なぜ3プロジェクトでは不十分なのか] |
| [例: Repositoryパターン] | [特定の問題] | [なぜ直接DBアクセスでは不十分なのか] |
