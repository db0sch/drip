class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.references :submission, foreign_key: true
      t.datetime :apply_date

      t.timestamps
    end
  end
end
