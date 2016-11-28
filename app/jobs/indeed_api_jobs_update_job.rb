class IndeedApiJobsUpdateJob < ApplicationJob
  queue_as :default

  def perform
    indeed = IndeedApi.new(
      publisher_key: ENV["indeed_publisher_key"],
      categories: Category.all.to_a,
      limit: 10
    )
    current_jobs = indeed.update_all_current_jobs
    puts "====> We now have #{current_jobs.count} current jobs <===="
  end
end
