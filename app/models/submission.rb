class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :job_offer
  has_one :interest
end
