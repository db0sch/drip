class UpdateJobOffers

  attr_reader :api

  def initialize(api)
    @api = api
  end

  def check_expiry
    joboffers = JobOffer.current.to_a
    jobs_expired = joboffers.select do |joboffer|
      result = @api.getjob(joboffer.jobkey)
      joboffer.expires! if expired?(result)
      joboffer.expired
      # rescue if expired?(result) fail
    end
    puts jobs_expired.count > 0 ? "#{joboffers} have expired" : "No job expired this time."
    joboffers
    #   # call the API and check if it return true
    #   if call_api_getjob_expiry(joboffer.jobkey) == true
    #     puts "JobOffer id: #{joboffer.id} and jobkey: #{joboffer.jobkey} is now expired !"
    #     joboffer.update(expired: true)
    #   end
    #   # if it doesn't return true, we don't touch the instance.
    # end
    # # messages for logs
    # current_jobs = JobOffer.current
    # if before_count != current_jobs.count
    #   puts "#{before_count - current_jobs.count} joboffers have expired"
    # else
    #   puts "No joboffer has expired."
    # end

    # current_jobs

  end

  def check_expiry_only_for(joboffer)
    result = @api.get_job(joboffer.jobkey)
    joboffer.expires! if expired?(result)
    joboffer
  end

  private

  def expired?(result = {})
    unless result["results"].nil? || result["results"].empty?
      expired = result['results'].first['expired']
      expired if expired.is_a?(TrueClass) || expired.is_a?(FalseClass)
    else
      false
      # should raise an exception if not truthy or falsy or if information is not there.
    end
  end
end
