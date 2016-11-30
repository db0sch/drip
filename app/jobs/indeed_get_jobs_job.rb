class IndeedGetJobsJob < ApplicationJob
  queue_as :default

  def perform(limit_query = nil)
    api = IndeedApi.new(publisher_key: ENV["indeed_publisher_key"])
    fetch_job_offers = FetchJobOffers.new(api, locations: [{city: "paris", country: "fr"}], limit: limit_query)
    joboffers = fetch_job_offers.run
    puts "===> Number of job offers loaded from Indeed API: #{joboffers ? joboffers.count : 0}"
  end
end
