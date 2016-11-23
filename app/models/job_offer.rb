class JobOffer < ApplicationRecord
  belongs_to :company
  belongs_to :category
  has_many :submissions
  has_many :users, through: :submissions
  has_many :interests, through: :submissions

  validates :title, :description, :category, presence: true
  validates_associated :company, :category
end
