class JobPreference < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user, :category, presence: true
  validates_associated :user, :category
end
