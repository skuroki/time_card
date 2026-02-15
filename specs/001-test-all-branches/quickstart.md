# クイックスタート: Enable tests on all branches

## 概要

この機能は GitHub Actions のワークフロー設定を変更し、すべてのブランチでテストを実行するようにします。

## 検証手順

### 1. 非Masterブランチでのテスト実行確認

1. 新しいブランチを作成する: `git checkout -b feature/test-ci`
2. 空のコミットを作成してプッシュする:
   ```bash
   git commit --allow-empty -m "Trigger CI"
   git push origin feature/test-ci
   ```
3. GitHub Actions のタブを開き、ワークフローが実行されていることを確認する。
4. `deploy` ジョブが **スキップ** されている（または実行されていない）ことを確認する。

### 2. Masterブランチでのデプロイ確認

1. （権限がある場合）`master` ブランチに変更をプッシュまたはマージする。
2. GitHub Actions でワークフローが実行され、`build` 成功後に `deploy` が実行されることを確認する。

## 開発者向けメモ

- `deploy.yml` の `if: github.ref == 'refs/heads/master'` 条件により制御されています。
- テストコマンド自体に変更はありません。
