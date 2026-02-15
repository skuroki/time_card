---
description: 利用可能な設計成果物に基づいて、既存のタスクを実行可能で依存関係順に並べられたGitHub Issueに変換します。
tools: ['github/github-mcp-server/issue_write']
---

## ユーザー入力

```text
$ARGUMENTS
```

先に進む前にユーザー入力を**必ず**考慮してください（入力が空でない場合）。

## 概要

1. リポジトリルートから `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` を実行し、FEATURE_DIR と AVAILABLE_DOCS リストをパースする。すべてのパスは絶対パスであること。引数内のシングルクォート（例: "I'm Groot"）については、エスケープ構文を使用すること: 例 'I'\''m Groot'（または可能ならダブルクォート: "I'm Groot"）。
2. 実行されたスクリプトから、**タスク**へのパスを抽出する。
3. 以下を実行してGitリモートを取得する:

```bash
git config --get remote.origin.url
```

> [!CAUTION]
> リモートが GITHUB URL である場合のみ次のステップに進んでください

4. リスト内の各タスクについて、GitHub MCPサーバーを使用して、Gitリモートを表すリポジトリに新しいIssueを作成する。

> [!CAUTION]
> リモートURLと一致しないリポジトリには、いかなる場合も絶対にIssueを作成しないでください
