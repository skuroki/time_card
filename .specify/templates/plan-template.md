# 実装計画: [FEATURE]

**ブランチ**: `[###-feature-name]` | **日付**: [DATE] | **仕様書**: [link]
**入力**: `/specs/[###-feature-name]/spec.md` の機能仕様書

**注記**: このテンプレートは `/speckit.plan` コマンドによって記入されます。実行フローについては `.specify/templates/commands/plan.md` を参照してください。

## 概要

[機能仕様書からの抜粋: 主要要件 + リサーチからの技術的アプローチ]

## 技術的コンテキスト

<!--
  アクションが必要: このセクションの内容を、プロジェクトの技術的詳細で
  置き換えてください。ここでの構造は、イテレーションプロセスをガイド
  するための参考として提示されています。
-->

**Language/Version (言語/バージョン)**: [例: Python 3.11, Swift 5.9, Rust 1.75 または 明確化が必要]  
**Primary Dependencies (主要な依存関係)**: [例: FastAPI, UIKit, LLVM または 明確化が必要]  
**Storage (ストレージ)**: [該当する場合、例: PostgreSQL, CoreData, files または N/A]  
**Testing (テスト)**: [例: pytest, XCTest, cargo test または 明確化が必要]  
**Target Platform (ターゲットプラットフォーム)**: [例: Linux server, iOS 15+, WASM または 明確化が必要]
**Project Type (プロジェクトタイプ)**: [single/web/mobile - ソース構造を決定する]  
**Performance Targets (パフォーマンス目標)**: [ドメイン固有、例: 1000 req/s, 10k lines/sec, 60 fps または 明確化が必要]  
**Constraints (制約事項)**: [ドメイン固有、例: <200ms p95, <100MB memory, オフライン対応 または 明確化が必要]  
**Scale/Scope (規模/スコープ)**: [ドメイン固有、例: 10k users, 1M LOC, 50 screens または 明確化が必要]

## 憲法チェック (Constitution Check)

*ゲート: フェーズ0のリサーチ前に通過必須。フェーズ1の設計後に再チェック。*

[憲法ファイルに基づいて決定されるゲート]

## プロジェクト構造

### ドキュメント (本機能用)

```text
specs/[###-feature]/
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
# [未使用なら削除] オプション 1: シングルプロジェクト (デフォルト)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [未使用なら削除] オプション 2: Webアプリケーション ("frontend" + "backend" が検出された場合)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [未使用なら削除] オプション 3: モバイル + API ("iOS/Android" が検出された場合)
api/
└── [上記backendと同じ]

ios/ または android/
└── [プラットフォーム固有の構造: 機能モジュール, UIフロー, プラットフォームテスト]
```

**構造決定**: [選択した構造を文書化し、上記でキャプチャした実際のディレクトリを参照]

## 複雑性の追跡 (Complexity Tracking)

> **憲法チェックに違反があり、正当化が必要な場合のみ記入**

| 違反 | 必要理由 | より単純な代替案が却下された理由 |
|-----------|------------|-------------------------------------|
| [例: 第4のプロジェクト] | [現在の必要性] | [なぜ3プロジェクトでは不十分なのか] |
| [例: Repositoryパターン] | [特定の問題] | [なぜ直接DBアクセスでは不十分なのか] |
