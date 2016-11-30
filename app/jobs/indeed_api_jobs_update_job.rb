class IndeedApiJobsUpdateJob < ApplicationJob
  queue_as :default

  def perform
    api = IndeedApi.new(publisher_key: ENV["indeed_publisher_key"])
    update_job_offers = UpdateJobOffers.new(api)
    puts "====> Let's check if some jobs are expired <===="
    update_job_offers.check_expiry
  end
end
