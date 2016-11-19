class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :job_offer
  has_one :interest

  validates :user, :job_offer, presence: true
  validates_associated :user, :job_offer
end
