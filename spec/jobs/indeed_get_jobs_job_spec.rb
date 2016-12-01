require 'rails_helper'

RSpec.describe IndeedGetJobsJob, type: :job do
  describe "#perform_later" do
    it "get jobs from Indeed Api (only new ones)" do
      ActiveJob::Base.queue_adapter = :test
      IndeedGetJobsJob.perform_later
      expect(IndeedGetJobsJob).to have_been_enqueued
    end
  end
end
