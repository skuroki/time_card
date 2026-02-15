# Tasks: Enable tests on all branches (GitHub Actions)

**Generated**: 2026-02-15
**Focus**: `.github/workflows/deploy.yml`
**Status**: In Progress

## Phase 1: Setup (Project Initialization)

- [x] T001 実装計画に従ってプロジェクト構造を確認（`.github/workflows/deploy.yml`の存在確認） .github/workflows/deploy.yml

## Phase 2: Foundation (Blocking Prerequisites)

- [x] T002 既存のワークフロー設定をバックアップ（内容確認） .github/workflows/deploy.yml

## Phase 3: User Story 1 - 全ブランチでのCI実行 (P1)

**Story Goal**: 任意のブランチへのプッシュで `build` ジョブ（テスト）が実行されるようにする。

**Independent Test**:
- 新しいブランチを作成し、コミットをプッシュして GitHub Actions の `build` ジョブが開始されることを確認する。

**Implementation Tasks**:

- [x] T003 [US1] ワークフローのトリガー設定を変更し、全ブランチで実行されるようにする .github/workflows/deploy.yml
  - `on: push: branches: [master]` を `branches: ['**']` または削除して全ブランチ対象に変更

## Phase 4: User Story 2 - Masterブランチでのデプロイフロー (P1)

**Story Goal**: `deploy` ジョブが `master` ブランチへのプッシュ時のみ実行されるように制限する。

**Independent Test**:
- 非masterブランチへのプッシュで `deploy` ジョブがスキップされることを確認する。
- `master` ブランチへのプッシュで `deploy` ジョブが実行されることを確認する。

**Implementation Tasks**:

- [x] T004 [US2] Deployジョブに条件分岐を追加し、masterブランチ以外ではスキップ設定 .github/workflows/deploy.yml
  - `jobs: deploy: if: github.ref == 'refs/heads/master'` (または `github.ref_name == 'master'`) を追加

## Final Phase: Cleanup & Cross-cutting Concerns

- [x] T005 [P] 全体の構文チェック（YAMLバリデーション） .github/workflows/deploy.yml
- [x] T006 [P] 不必要なコメントやバックアップの削除 .github/workflows/deploy.yml

## Implementation Strategy

1. **MVP First**: T003を実施し、まずテストが全ブランチで走ることを確認する。
2. **Safety**: T004を実施し、非masterブランチからの誤デプロイを防ぐ。これはT003とセットでリリースすることが望ましい（誤デプロイ防止のため）。 T003とT004は同一コミットで行うのが安全だが、タスクとしては分ける。

## Dependencies

1. **User Story 1** (T003) MUST be completed before checking **User Story 2** fully works logically, but technically T004 can be written first.
2. **User Story 2** (T004) is CRITICAL to avoid deploying feature branches if T003 is applied.

## Parallel Execution Examples

- **T005 (Syntax Check)** can be done in parallel with implementation drafting.
