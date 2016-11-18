class CreateJobOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :job_offers do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.references :company, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
