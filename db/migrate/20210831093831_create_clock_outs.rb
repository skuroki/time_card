class CreateClockOuts < ActiveRecord::Migration[6.1]
  def change
    create_table :clock_outs do |t|
      t.references :attendance, null: false, foreign_key: true, index: { unique: true }
      t.datetime :finished_at, null: false

      t.timestamps
    end
  end
end
