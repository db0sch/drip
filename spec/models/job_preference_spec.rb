require 'rails_helper'

RSpec.describe JobPreference, type: :model do
  let(:category) { Category.new(name:"Delivery") }
  let(:user) { User.new(name:"John Doe", email:"john.doe@email.com", messenger_uid: "123456789", driver_licence: false) }

  subject { JobPreference.new(user: user, category: category) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a User" do
      subject.user = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a Category" do
      subject.category = nil
      expect(subject).to_not be_valid
    end

    it "is not valid if User is not valid either" do
      subject.user = User.new
      expect(subject).to_not be_valid
    end

    it "is not valid is Category is not valid either" do
      subject.category = Category.new
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end
end
