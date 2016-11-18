class User < ApplicationRecord
  has_many :submissions
  has_many :interests, through: :submissions
  has_many :job_preferences
  has_many :categories, through: job_preferences
end
