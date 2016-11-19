require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:company) { Company.new(name:"Apple, Inc") }
  let(:category) { Category.new(name:"Delivery") }
  let(:user) { User.new(name:"John Doe", email:"john.doe@email.com", messenger_uid: "123456789", driver_licence: false) }
  let(:job_offer) {
    JobOffer.new(
    title:"Delivery guy for Foodora",
    description:"Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
    company: company,
    category: category,
    start_date: Date.today
    )
  }

  subject {
    Submission.new(user: user, job_offer: job_offer)
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a User" do
      subject.user = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a Job Offer" do
      subject.job_offer = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if User is not valid either" do
      subject.user = User.new
      expect(subject).to_not be_valid
    end

    it "is not valid if Job Offer is not valid either" do
      subject.job_offer = JobOffer.new
      expect(subject).to_not be_valid
    end

  end

  describe "Associations" do
    it { should have_one(:interest) }
    it { should belong_to(:user) }
    it { should belong_to(:job_offer) }
  end
end
