<!--
SYNC IMPACT REPORT
Version: 1.0.0 -> 1.1.0
Changes:
- Added Principle V: Japanese Language Output (Official language requirement).
Templates Status:
- templates/spec-template.md: ✅ Compatible
- templates/tasks-template.md: ✅ Compatible
Todo:
- None.
-->

# Attendance Tracking System Constitution

## Core Principles

### I. Rails First & Standard Idioms (Railsファーストと標準イディオム)
Railsの標準機能と慣習を最大限に尊重し、活用すること。外部Gemへの依存は必要最小限に留めるべきである。
特に重要かつ譲れないルールとして、**テストデータの作成には `factory_bot` を一切使用しない**。代わりにActiveRecordの標準機能（`User.create!`, `fixtures`等）を使用し、シンプルさとRails標準の挙動を維持すること。これにより、特定のGemへの知識依存を減らし、メンテナンス性を高める。

### II. Dockerized Environment (Docker環境の徹底)
開発、テスト、実行のすべてのフェーズにおいてDockerコンテナを環境の正（Source of Truth）とすること。
開発者のローカルマシンの設定の違いによる「環境依存のバグ」を排除するため、テスト実行やサーバー起動は原則としてDockerコンテナ経由（`bin/test` 等）で行う必要がある。`docker-compose.yml` および `Dockerfile` が環境定義の唯一のドキュメントである。

### III. Test Driven & Focused (テスト駆動と集中)
RSpecを用いたテスト記述を必須とする。
アプリケーションの信頼性を担保するため、モデルの単体テストだけでなく、実際のユーザー操作をシミュレートするE2Eテスト（System Spec）を重視すること。変更を加える際は、既存のテストがパスすることを確認し、新規機能には必ずテストを付随させること。

### IV. Simplicity & Readability (単純性と可読性)
コードは「書く時間」よりも「読まれる時間」の方が圧倒的に長いことを意識し、複雑さよりも単純さと可読性を優先すること。
過度なDRY（Don't Repeat Yourself）の追求や複雑なメタプログラミングによって可読性を犠牲にしてはならない。特にテストコードにおいては、セットアップの重複を許容してでも、テストケース単体でロジックが完結して読める状態（DAMP: Descriptive And Meaningful Phrases）を好む。

### V. Japanese Language Output (日本語出力の徹底)
出力する仕様書、技術ドキュメント、および各指示に対する返答は、原則として全て **日本語** で行うこと。
これにより、チーム全体での仕様理解の齟齬を防ぎ、コミュニケーションを円滑にする。

## Additional Constraints (追加の制約事項)

### Technology Stack
- **Ruby**: 3.3.1 (またはプロジェクト指定のバージョン)
- **Framework**: Ruby on Rails
- **Database**: PostgreSQL
- **Testing Framework**: RSpec (factory_bot禁止)

## Development Workflow (開発ワークフロー)

### Quality Control Rules
1. **No Magic**: テストデータ作成時、明示的でないデフォルト値や隠蔽された副作用を持つヘルパーの作成を避ける。
2. **Standard Commands**: テスト実行は `bin/test` または `docker-compose run ...` を使用して行う。
3. **CI Readiness**: ローカルのDocker環境で通るテストは、CI環境でも通るべきである。

## Governance

本憲章はプロジェクトの技術的および運用上の最高規則であり、これに反するコードレビューやプラクティスは修正を求められる。

### Amendments (改正手続)
本憲章の変更は、プロジェクトのフェーズ変更や技術的負債の解消など、明確な理由がある場合にのみ行われる。変更を行う際は、バージョン番号を更新し、変更理由を記録しなければならない。また、憲章の変更に伴い、関連するテンプレートやドキュメント（README等）の更新も義務付けられる。

**Version**: 1.1.0 | **Ratified**: 2026-02-14 | **Last Amended**: 2026-02-14
