class Company < ApplicationRecord
  has_many :job_offers

  validates :name, presence: true
  validates :name, uniqueness: true
end
