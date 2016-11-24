require 'rails_helper'
require 'date'

RSpec.describe Interest, type: :model do
  let(:company) { Company.new(name:"Apple, Inc") }
  let(:category) { Category.new(name:"Delivery") }
  let(:user) {
    User.new(
      name:"John Doe",
      email:"john.doe@email.com",
      messenger_uid: "123456789",
      driver_licence: false
    )
  }
  let(:job_offer) {
    JobOffer.new(
    title:"Delivery guy for Foodora",
    description:"Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
    company: company,
    category: category,
    start_date: Date.today,
    jobkey: "425ee2469338da27"
    )
  }
  let(:submission) { Submission.new(user: user, job_offer: job_offer) }

  subject {
    Interest.new(
      submission: submission,
      apply_date: DateTime.now
    )
  }

  describe "Validations" do

    it "is valid with valid argments" do
      expect(subject).to be_valid
    end

    it "is not valid without a submission" do
      subject.submission = nil
      expect(subject).to_not be_valid
    end

    it "should validates_associates submission" do
      expect(subject.submission).to be_valid
    end

    it "should not be valid if submission is not valid either" do
      subject.submission = Submission.new(user: nil, job_offer: nil)
      expect(subject.submission).to_not be_valid
    end

    it "is valid even if apply_date is nil" do
      subject.apply_date = nil
      expect(subject).to be_valid
    end

  end

  describe ".apply_date" do
    it "is a ActiveSupport::TimeWithZone object" do
      expect(subject.apply_date.class == ActiveSupport::TimeWithZone).to be true
    end
  end

  describe "Associations" do
    it { should belong_to(:submission) }
  end

end
