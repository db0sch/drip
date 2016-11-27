class IndeedGetJobsJob < ApplicationJob
  queue_as :default

  def perform
    indeed = IndeedApi.new(
      publisher_key: ENV["indeed_publisher_key"],
      categories: Category.all.to_a,
      limit: 10
    )
    joboffers = indeed.get_jobs
    puts "===> Number of job offers loaded from Indeed API: #{joboffers ? joboffers.count : 0}"
  end
end
