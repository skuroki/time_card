## プロジェクト概要

Rails製の勤怠管理アプリケーション。出勤・退勤・休憩の記録と、月次レポートの表示機能を持つ。

## 技術スタック

- **言語 / フレームワーク**: Ruby 3.3.1 / Rails 7.1
- **データベース**: SQLite3（開発・テスト環境）、PostgreSQL（本番環境）
- **フロントエンド**: Hotwire（Turbo + Stimulus）、Importmap
- **テスト**: RSpec + Capybara + Selenium WebDriver（Dockerコンテナ上のリモートChrome）
- **CI/CD**: GitHub Actions → Fly.io デプロイ

## アーキテクチャ

### モデル構成

```
Attendance (勤怠)
  └── has_one :clock_out          # 退勤時刻
  └── has_many :rests             # 休憩
        └── has_one :rest_finish  # 休憩終了
```

- `Attendance`: `work_date`（ユニーク）と `started_at`（出勤時刻）を持つ
- `ClockOut`: `finished_at`（退勤時刻）
- `Rest`: `started_at`（休憩開始）
- `RestFinish`: `finished_at`（休憩終了）

### 認証

全ページに HTTP Basic 認証が必須。ユーザー名は `skuroki`、パスワードは環境変数 `TIME_CARD_PASSWORD`。

### ルーティング

```
root 'attendances#index'
resources :attendances do
  member  { get :working_time }   # 稼働時間 AJAX エンドポイント
  collection { get :report }      # 月次レポート
end
resources :clock_outs
resources :rests
resources :rest_finishes
```

## テスト方針

### テスト種別と配置

```
spec/
├── system/       # Capybara + Selenium による E2E テスト
├── integration/  # コンテナ設定・インフラ検証
├── models/       # モデルの単体テスト
├── controllers/  # コントローラーの単体テスト
└── support/      # テストヘルパー・設定
```

### テストの実行

```bash
# 全テスト
bin/test

# 特定ファイル
bin/test spec/system/attendance_workflow_spec.rb

# 行番号指定
bin/test spec/system/attendance_workflow_spec.rb:15

# ウォッチモード
bin/test-watch

# デバッグモード（binding.pry 使用可）
bin/test-debug spec/system/attendance_workflow_spec.rb

# インタラクティブシェル
bin/test-debug --shell
```

### システムテストの認証

システムテストでは `sign_in_with_basic_auth` ヘルパーを使って Basic 認証を通過する。

```ruby
before { sign_in_with_basic_auth }
```

### 失敗時スクリーンショット

システムテスト失敗時は `tmp/test_results/` にスクリーンショットが自動保存される。

## 環境構築

```bash
bundle install
rails db:create db:migrate
cp .env.development .env.test   # TIME_CARD_PASSWORD を設定
```

## コーディング規約

- RuboCop + RuboCop-Rails の設定に従う
- 日本語のコメント・UI文字列は維持する
- Turbo を活用し、不要な全ページリロードを避ける
