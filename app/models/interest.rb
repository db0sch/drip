class Interest < ApplicationRecord
  belongs_to :submission

  validates :submission, presence: true
  validates_associated :submission

end
