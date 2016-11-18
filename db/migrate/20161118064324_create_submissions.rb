class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.references :user, foreign_key: true
      t.references :job_offer, foreign_key: true
      t.datetime :read_at

      t.timestamps
    end
  end
end
