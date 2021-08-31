class CreateAttendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.date :work_date, null: false
      t.datetime :started_at, null: false

      t.timestamps

      t.index :work_date, unique: true
    end
  end
end
