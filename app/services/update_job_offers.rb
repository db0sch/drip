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
