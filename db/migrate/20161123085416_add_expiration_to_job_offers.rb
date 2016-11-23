class AddExpirationToJobOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :job_offers, :expired, :boolean
  end
end
