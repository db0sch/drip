require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    User.new(name:"John Doe", email:"john.doe@email.com", messenger_uid: "123456789", driver_licence: false)
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a messenger_uid" do
      subject.messenger_uid = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a driver_licence info" do
      subject.driver_licence = nil
      expect(subject).to_not be_valid
    end
  end
end
