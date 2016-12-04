class JobOffer < ApplicationRecord
  before_create :default_values

  belongs_to :company
  belongs_to :category
  has_many :submissions
  has_many :users, through: :submissions
  has_many :interests, through: :submissions

  validates :title, :description, :category, :company, :jobkey, presence: true
  validates_associated :company, :category
  validates :jobkey, uniqueness: true

  # default_scope { where(expired: ) }
  scope :current, -> { where(expired: false) }
  scope :expired, -> { where(expired: true) }

  def expires!
    self.update(expired: true)
  end

  def approved?
    return approved
  end

  def approved!
    update(approved: true)
    return approved
  end

  private

  def default_values
    self.approved ||= false
  end
end
