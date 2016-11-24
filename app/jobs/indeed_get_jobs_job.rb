class IndeedGetJobsJob < ApplicationJob
  queue_as :default

  def perform
    indeed = IndeedApi.new(
      publisher_key: ENV['indeed_publisher_key'],
      categories: Category.to_array,
    )
    indeed.get_jobs
  end
end
