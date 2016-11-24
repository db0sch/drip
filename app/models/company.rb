class Company < ApplicationRecord
  has_many :job_offers

  # validates :name, presence: true, allow_blank: true
  validates :name, uniqueness: true
end
