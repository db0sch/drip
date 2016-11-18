class User < ApplicationRecord
  has_many :submissions
  has_many :interests, through: :submissions
  has_many :job_preferences
  has_many :categories, through: :job_preferences

  validates :name, :email, :messenger_uid, presence: true
  # validates :messenger_uid, uniqueness: true
  validates :driver_licence, inclusion: { in: [true, false] }
end
