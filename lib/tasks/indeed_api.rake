namespace :indeed_api do
  desc "Get X jobs offers from Indeed API for each categories"
  task :get_jobs, [:limit] => :environment do |t, args|
    puts "Enqueuing Indeed jobs offers load process"
    limit = args[:limit].to_i
    IndeedGetJobsJob.perform_later(limit)
  end

  desc "Check if current jobs are expired on Indeed Api"
  task check_jobs_expiry: :environment do
    puts "Enqueuing Indeed jobs offers expiry check process"
    IndeedApiJobsUpdateJob.perform_later
  end

end
