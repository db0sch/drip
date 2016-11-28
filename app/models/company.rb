class Company < ApplicationRecord
  has_many :job_offers

  validates :name, uniqueness: true
end
