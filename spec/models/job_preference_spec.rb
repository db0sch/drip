require 'rails_helper'

RSpec.describe JobPreference, type: :model do

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end
end
