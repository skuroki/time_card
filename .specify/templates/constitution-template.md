# [PROJECT_NAME] 憲法 (Constitution)
<!-- 例: Spec Constitution, TaskFlow Constitution など -->

## コア原則 (Core Principles)

### [PRINCIPLE_1_NAME]
<!-- 例: I. ライブラリファースト -->
[PRINCIPLE_1_DESCRIPTION]
<!-- 例: すべての機能はスタンドアロンライブラリとして開始する。ライブラリは自己完結し、独立してテスト可能で、文書化されている必要がある。明確な目的が必要 - 組織化のためだけのライブラリは不可 -->

### [PRINCIPLE_2_NAME]
<!-- 例: II. CLI インターフェース -->
[PRINCIPLE_2_DESCRIPTION]
<!-- 例: すべてのライブラリはCLI経由で機能を公開する。テキスト入出力プロトコル: stdin/args → stdout, エラー → stderr。JSON + 人間が読める形式をサポート -->

### [PRINCIPLE_3_NAME]
<!-- 例: III. テストファースト (交渉不可) -->
[PRINCIPLE_3_DESCRIPTION]
<!-- 例: TDDは必須: テストを書く → ユーザー承認 → テスト失敗 → 実装。Red-Green-Refactor サイクルを厳格に強制 -->

### [PRINCIPLE_4_NAME]
<!-- 例: IV. 統合テスト -->
[PRINCIPLE_4_DESCRIPTION]
<!-- 例: 統合テストが必要な重点領域: 新しいライブラリの契約テスト、契約の変更、サービス間通信、共有スキーマ -->

### [PRINCIPLE_5_NAME]
<!-- 例: V. 可観測性 (Observability), VI. バージョニングと破壊的変更, VII. 単純性 (Simplicity) -->
[PRINCIPLE_5_DESCRIPTION]
<!-- 例: テキストI/Oによりデバッグ可能性を確保する。構造化ロギング必須。または: MAJOR.MINOR.BUILD 形式。または: 単純に始める、YAGNI原則 -->

## [SECTION_2_NAME]
<!-- 例: 追加の制約事項、セキュリティ要件、パフォーマンス基準 など -->

[SECTION_2_CONTENT]
<!-- 例: テクノロジースタック要件、コンプライアンス基準、デプロイポリシー など -->

## [SECTION_3_NAME]
<!-- 例: 開発ワークフロー、レビュープロセス、品質ゲート など -->

[SECTION_3_CONTENT]
<!-- 例: コードレビュー要件、テストゲート、デプロイ承認プロセス など -->

## ガバナンス (Governance)
<!-- 例: 憲法は他のすべての慣行に優先する。修正には文書化、承認、移行計画が必要 -->

[GOVERNANCE_RULES]
<!-- 例: すべてのPR/レビューは準拠を確認する必要がある。複雑さは正当化されなければならない。実行時の開発ガイダンスには [GUIDANCE_FILE] を使用する -->

**バージョン**: [CONSTITUTION_VERSION] | **批准日**: [RATIFICATION_DATE] | **最終修正日**: [LAST_AMENDED_DATE]
<!-- 例: Version: 2.1.1 | Ratified: 2025-06-13 | Last Amended: 2025-07-16 -->
