require 'rails_helper'

RSpec.describe Interest, type: :model do

  describe "Associations" do
    it { should belong_to(:submission) }
  end
end
