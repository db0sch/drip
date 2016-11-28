require 'json'
require 'open-uri'

class IndeedApi

  def initialize(attributes = {})
    @publisher_key = attributes[:publisher_key]
    @categories = attributes[:categories]
    @locations = attributes[:locations] || ["paris", "fr"]
    @limit = attributes[:limit]
    @companies = Company.all.to_a
  end

  def get_jobs
    # call the api with parameter, for each category
    array_of_attributes = @categories.map do |category|
      call_api_search(category)
    end

    # reject all job_offers which are already in the database (comparing jobkeys)
    jobkeys = get_all_jobkeys
    array_of_attributes.flatten!.reject! do |attributes|
      jobkeys.include? attributes[:jobkey]
    end

    # call the get job api, and update the attributes hashes
    array_of_attributes.map! do |result|
      call_api_getjob(result)
    end

    # create JobOffer instances from these attributes.
    create_job_offers_instances_with array_of_attributes
    # the method will return JobOffer instances.
  end

  def update_all_current_jobs
    # load all current jobs (with expired: true)
    joboffers = JobOffer.current
    before_count = joboffers.count
    joboffers.each do |joboffer|
      # call the API and check if it return true
      if call_api_getjob_expiry(joboffer.jobkey) == true
        puts "JobOffer id: #{joboffer.id} and jobkey: #{joboffer.jobkey} is now expired !"
        joboffer.update(expired: true)
      end
      # if it doesn't return true, we don't touch the instance.
    end
    # messages for logs
    current_jobs = JobOffer.current
    if before_count != current_jobs.count
      puts "#{before_count - current_jobs.count} joboffers have expired"
    else
      puts "No joboffer has expired."
    end

    current_jobs
  end

  private

  def call_api_search(category)
    begin
      params = {
        category: category.name,
        city: @locations[0],
        country: @locations[1],
      }
      url = "http://api.indeed.com/ads/apisearch?publisher=#{@publisher_key}&q=#{params[:category]}&l=#{params[:city]}&sort=&radius=&st=&jt=&start=&limit=#{@limit}&fromage=&filter=&latlong=1&co=#{params[:country]}&format=json&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
      offers_serialized = open(url).read
      offers = JSON.parse(offers_serialized)

      fail unless offers['results']

      offers_attributes = offers['results'].map do |offer|
        attributes = {
          title: offer["jobtitle"],
          company: find_or_create_company(offer["company"]),
          description: offer["snippet"],
          formatted_location: offer["formattedLocation"],
          city: offer["city"],
          country: offer["country"],
          date: DateTime.parse(offer["date"]),
          source_primary: "indeed",
          source_original: offer["source"],
          url_source_primary: offer["url"],
          jobkey: offer["jobkey"],
          category: category
        }
      end
    rescue => e
      puts "***** An error occurred call_api with message #{e.message}: retrying in 5 seconds - category: #{params[:category]}*****"
      sleep 2
      retry
    end
    offers_attributes
  end

  def call_api_getjob(job_offer_attributes)
    begin
      url = "http://api.indeed.com/ads/apigetjobs?publisher=#{@publisher_key}&jobkeys=#{job_offer_attributes[:jobkey]}&v=2&format=json"
      offer_serialized = open(url).read
      offer = JSON.parse(offer_serialized)
      fail unless offer['results']
      return job_offer_attributes if offer['results'].empty?
      p "updating job_offer #{job_offer_attributes[:jobkey]}"
    rescue => e
      puts "***** An error occurred call_api with message #{e.message}: retrying in 5 seconds - jobkey: #{job_offer_attributes[:jobkey]}*****"
      sleep 2
      retry
    end
    job_offer_attributes[:description_additional] = offer['results'].first['snippet']
    job_offer_attributes[:url_source_original] = offer['results'].first['url']
    job_offer_attributes[:expired] = offer['results'].first['expired']
    job_offer_attributes
  end

  def call_api_getjob_expiry(jobkey)
    begin
      url = "http://api.indeed.com/ads/apigetjobs?publisher=#{@publisher_key}&jobkeys=#{jobkey}&v=2&format=json"
      offer_serialized = open(url).read
      offer = JSON.parse(offer_serialized)
      fail unless offer['results']
      puts "checking expiration of job_offer with jobkey: #{jobkey}"
      expired = offer['results'].first['expired']
    rescue => e
      puts "***** An error occurred call_api with message #{e.message}: retrying in 5 seconds - jobkey: #{job_offer_attributes[:jobkey]}*****"
      sleep 2
      retry
    end
    expired
  end

  def find_or_create_company(name)
    if company = @companies.find { |company| company.name == name }
      puts "Company: #{name} exist !!!"
      return company
    else
      puts "Company: #{name} doesn't exist yet. Let's create it."
      company = Company.create(name: name)
      @companies << company
      return company
    end

  end

  def get_all_jobkeys
    JobOffer.pluck(:jobkey)
  end

  def create_job_offers_instances_with(bunch_of_attributes)
    instances = []
    bunch_of_attributes.each do |attr|
      joboffer = JobOffer.new(attr)
      if joboffer.save
        instances << joboffer
        puts "Job_offer #{attr[:jobkey]} has been created"
      else
        puts "Job_offer #{attr[:jobkey]} has not been created because #{joboffer.errors.messages}"
      end
    end
    instances
  end
end
