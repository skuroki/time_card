class CreateRestFinishes < ActiveRecord::Migration[6.1]
  def change
    create_table :rest_finishes do |t|
      t.references :rest, null: false, foreign_key: true, index: { unique: true }
      t.datetime :finished_at

      t.timestamps
    end
  end
end
