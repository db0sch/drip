class IndeedGetJobsJob < ApplicationJob
  queue_as :default

  def perform(limit_query = nil)
    indeed = IndeedApi.new(
      publisher_key: ENV["indeed_publisher_key"],
      categories: Category.all.to_a,
      limit: limit_query || 10
    )
    joboffers = indeed.get_jobs
    puts "===> Number of job offers loaded from Indeed API: #{joboffers ? joboffers.count : 0}"
  end
end
