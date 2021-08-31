class CreateRests < ActiveRecord::Migration[6.1]
  def change
    create_table :rests do |t|
      t.references :attendance, null: false, foreign_key: true
      t.datetime :started_at, null: false

      t.timestamps
    end
  end
end
