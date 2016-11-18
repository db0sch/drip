require 'rails_helper'

RSpec.describe Submission, type: :model do

  describe "Associations" do
    it { should have_one(:interest) }
    it { should belong_to(:user) }
    it { should belong_to(:job_offer) }
  end
end
