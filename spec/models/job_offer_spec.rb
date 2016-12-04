require 'rails_helper'

RSpec.describe JobOffer, type: :model do
  let(:category) { Category.new(name:"Delivery") }
  let(:company) { Company.new(name:"Apple, Inc") }

  subject {
    JobOffer.new(
      title:"Delivery guy for Foodora",
      description:"Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
      company: company,
      category: category,
      start_date: Date.today,
      jobkey: "425ee2469338da27",
      expired: false
    )
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a title" do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a description" do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a company" do
      subject.company = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a category" do
      subject.category = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a jobkey' do
      subject.jobkey = nil
      expect(subject).to_not be_valid
    end

    it "should validates_associates category" do
      expect(subject.category).to be_valid
    end

    it "should validates_associates company" do
      expect(subject.company).to be_valid
    end

    it 'is not approved by default' do
      subject.save
      expect(subject.approved).to be false
    end
  end

  describe "Associations" do
    it { should have_many(:submissions) }
    it { should have_many(:users) }
    it { should belong_to(:company) }
    it { should belong_to(:category) }
    it { should have_many(:interests) }
  end

  describe "#approved!" do
    it "approves the job offer" do
      subject.approved!
      expect(subject.approved?).to be true
    end
  end

  describe "#approved?" do
    it "returns if the job offer is approved or not" do
      subject.save
      expect(subject.approved?).to be(false)
      subject.approved!
      expect(subject.approved?).to be(true)
    end
  end

  describe "#expires?" do
    it "returns the value of .expired" do
      subject.save
      expect(subject.expired?).to be(false)
      subject.expires!
      expect(subject.expired?).to be(true)
    end
  end

  describe "#expires!" do
    it "returns set expired: true and returns true" do
      subject.save
      expect(subject.expired?).to be(false)
      expect(subject.expires!).to be(true)
      expect(subject.expired?).to be(true)
    end
  end

  describe "Scopes" do
    it "has a scope for approved job offers" do
      subject.save
      expect(JobOffer.approved.count).to be == 0
      subject.approved!
      expect(JobOffer.approved.count).to be == 1
      expect(JobOffer.approved.last).to be_a(JobOffer)
      expect(JobOffer.approved.last.approved?).to be true
    end

    it "has a scope for not_approved job offers" do
      subject.save
      expect(JobOffer.not_approved.count).to be == 1
      expect(JobOffer.not_approved.last).to be_a(JobOffer)
      expect(JobOffer.not_approved.last.approved?).to be false
      subject.approved!
      expect(JobOffer.not_approved.count).to be == 0
    end

    it "has a scope for current (not expired) job offers" do
      subject.save
      expect(JobOffer.current.count).to be == 1
      expect(JobOffer.current.last).to be_a(JobOffer)
      expect(JobOffer.current.last.expired?).to be false
      subject.expires!
      expect(JobOffer.current.count).to be == 0
    end

    it "has a scope for expired job offers" do
      subject.save
      expect(JobOffer.expired.count).to be == 0
      subject.expires!
      expect(JobOffer.expired.count).to be == 1
      expect(JobOffer.expired.last).to be_a(JobOffer)
      expect(JobOffer.expired.last.expired?).to be true
    end
  end
end
