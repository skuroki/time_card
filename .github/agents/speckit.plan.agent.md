---
description: プランテンプレートを使用して実装計画ワークフローを実行し、設計成果物を生成します。
handoffs: 
  - label: タスクの作成 (Create Tasks)
    agent: speckit.tasks
    prompt: 計画をタスクに分解してください (Break the plan into tasks)
    send: true
  - label: チェックリストの作成 (Create Checklist)
    agent: speckit.checklist
    prompt: 以下のドメインのチェックリストを作成してください... (Create a checklist for the following domain...)
---

## ユーザー入力

```text
$ARGUMENTS
```

先に進む前にユーザー入力を**必ず**考慮してください（入力が空でない場合）。

## 概要

1. **セットアップ**: リポジトリルートから `.specify/scripts/bash/setup-plan.sh --json` を実行し、JSONをパースして FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH を取得する。引数内のシングルクォート（例: "I'm Groot"）については、エスケープ構文を使用すること: 例 'I'\''m Groot'（または可能ならダブルクォート: "I'm Groot"）。

2. **コンテキストの読み込み**: FEATURE_SPEC と `.specify/memory/constitution.md` を読み込む。IMPL_PLAN テンプレート（すでにコピー済み）をロードする。

3. **計画ワークフローの実行**: IMPL_PLAN テンプレートの構造に従って以下を行う:
   - 技術的コンテキストを埋める（不明点は "NEEDS CLARIFICATION" とマーク）
   - 憲法から憲法チェックセクションを埋める
   - ゲートを評価する（違反が正当化されない場合はエラー）
   - フェーズ 0: research.md を生成（すべての NEEDS CLARIFICATION を解決）
   - フェーズ 1: data-model.md, contracts/, quickstart.md を生成
   - フェーズ 1: エージェントスクリプトを実行してエージェントコンテキストを更新
   - 設計後に憲法チェックを再評価

4. **停止と報告**: フェーズ2の計画後にコマンドは終了する。ブランチ、IMPL_PLANのパス、生成された成果物を報告する。

## フェーズ

### フェーズ 0: アウトラインとリサーチ

1. 上記の **技術的コンテキストから不明点を抽出**:
   - 各 NEEDS CLARIFICATION → リサーチタスク
   - 各依存関係 → ベストプラクティスタスク
   - 各統合 → パターンのタスク

2. **リサーチエージェントを生成してディスパッチ**:

   ```text
   技術的コンテキスト内の各不明点について:
     タスク: "{機能コンテキスト}のための{不明点}を調査する"
   各技術選択について:
     タスク: "{ドメイン}における{技術}のベストプラクティスを見つける"
   ```

3. **調査結果を統合** して `research.md` に以下の形式で記述:
   - 決定 (Decision): [選択したもの]
   - 根拠 (Rationale): [なぜ選んだか]
   - 検討した代替案 (Alternatives considered): [他に何を評価したか]

**出力**: すべての NEEDS CLARIFICATION が解決された research.md

### フェーズ 1: 設計と契約 (Contracts)

**前提条件:** `research.md` が完了していること

1. **機能仕様からエンティティを抽出** → `data-model.md`:
   - エンティティ名、フィールド、関係
   - 要件からの検証ルール
   - 該当する場合は状態遷移

2. **機能要件からAPI契約を生成** → `/contracts/`:
   - 各ユーザーアクションに対して → エンドポイント
   - 標準的な REST/GraphQL パターンを使用
   - OpenAPI/GraphQL スキーマを `/contracts/` に出力

3. **エージェントコンテキストの更新**:
   - `.specify/scripts/bash/update-agent-context.sh copilot` を実行する
   - これらのスクリプトは、どのAIエージェントが使用されているかを検出する
   - 適切なエージェント固有のコンテキストファイルを更新する
   - 現在の計画からの新しい技術のみを追加する
   - マーカー間の手動追加分は維持する

**出力**: data-model.md, /contracts/*, quickstart.md, エージェント固有ファイル

## 主要ルール

- 絶対パスを使用する
- ゲートの失敗や未解決の明確化がある場合はエラーとする
