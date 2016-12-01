require 'rails_helper'

RSpec.describe IndeedApiJobsUpdateJob, type: :job do
  describe "#perform_later" do
    it "updates all the job (check if expired)" do
      ActiveJob::Base.queue_adapter = :test
      IndeedApiJobsUpdateJob.perform_later
      expect(IndeedApiJobsUpdateJob).to have_been_enqueued
    end
  end

end
