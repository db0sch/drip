class ChangeApprovedOnJobOffers < ActiveRecord::Migration[5.0]
  def change
    change_column :job_offers, :approved, :boolean, default: false
  end
end
