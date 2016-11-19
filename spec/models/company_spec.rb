require 'rails_helper'

RSpec.describe Company, type: :model do
  subject { Company.new(name:"Apple, Inc") }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it { should have_many(:job_offers) }
  end
end
