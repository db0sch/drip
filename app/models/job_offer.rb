class JobOffer < ApplicationRecord

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
  scope :approved, -> { where(approved: true) }
  scope :not_approved, -> { where(approved: false) }

  def expires!
    update(expired: true)
    expired
  end

  def expired?
    expired
  end

  def approved?
    approved
  end

  def approved!
    update(approved: true)
    approved
  end

  def self.select_by_category(category)
    JobOffer.approved.select do |joboffer|
      joboffer.category == category
    end
  end
end
