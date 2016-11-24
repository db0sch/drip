class AddInfosToJobOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :job_offers, :description_additional, :text
    add_column :job_offers, :formatted_location, :string
    add_column :job_offers, :city, :string
    add_column :job_offers, :country, :string
    add_column :job_offers, :date, :datetime
    add_column :job_offers, :source_primary, :string
    add_column :job_offers, :source_original, :string
    add_column :job_offers, :url_source_primary, :text
    add_column :job_offers, :url_source_original, :text
    add_column :job_offers, :jobkey, :string
  end
end
