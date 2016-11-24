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
      jobkey: "425ee2469338da27"
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
  end

  describe "Associations" do
    it { should have_many(:submissions) }
    it { should have_many(:users) }
    it { should belong_to(:company) }
    it { should belong_to(:category) }
    it { should have_many(:interests) }
  end
end
