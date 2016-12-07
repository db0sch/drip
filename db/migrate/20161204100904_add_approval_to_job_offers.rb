class AddApprovalToJobOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :job_offers, :approved, :boolean
  end
end
