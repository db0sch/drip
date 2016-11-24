class Category < ApplicationRecord
  has_many :job_preferences
  has_many :users, through: :job_preferences
  has_many :job_offers

  validates :name, presence: true

  def self.to_array
    Category.all.map do |category|
      category
    end
  end
end
