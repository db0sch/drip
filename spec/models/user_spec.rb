require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes"
  it "is not valid without a name"
  it "is not valid without an email"
  it "is not valid without a messenger_uid"
  it "is not valid without a driver_licence info"
end
