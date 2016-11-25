require 'json'
require 'open-uri'

class IndeedApi

  def initialize(attributes = {})
    @publisher_key = attributes[:publisher_key]
    @categories = attributes[:categories]
    @locations = attributes[:locations] || ["paris", "fr"]
  end

  def get_jobs
    # call the api with parameter, for each category
    results_by_category = {}
    @categories.each do |category|
      results_by_category[category] = call_api_search(category.name)
    end
    # create a job_offer instance for each result
    job_offers = []
    results_by_category.each do |category, results|
      results.each do |result|
        unless JobOffer.find_by_jobkey(result["jobkey"])
          job_offers << create_job_offers(result, category)
        end
      end
    end
    # update joboffer with a new call to the API (Get_Job Indeed API)
    job_offers.compact.each { |job_offer| update_infos(job_offer) if job_offer.url_source_original } if job_offers.any?
  end

  private

  def call_api_search(category)
    begin
      params = {
        category: category,
        city: @locations[0],
        country: @locations[1],
        limit: 30,
      }
      url = "http://api.indeed.com/ads/apisearch?publisher=#{@publisher_key}&q=#{params[:category]}&l=#{params[:city]}&sort=&radius=&st=&jt=&start=&limit=#{params[:limit]}&fromage=&filter=&latlong=1&co=#{params[:country]}&format=json&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
      offers_serialized = open(url).read
      offers = JSON.parse(offers_serialized)
      fail unless offers['results']
    rescue => e
      puts "***** An error occurred call_api with message #{e.message}: retrying in 5 seconds - category: #{params[:category]}*****"
      sleep 2
      retry
    end
    return offers['results']
  end

  def call_api_getjob(jobkey)
    begin
      url = "http://api.indeed.com/ads/apigetjobs?publisher=#{@publisher_key}&jobkeys=#{jobkey}&v=2&format=json"
      offers_serialized = open(url).read
      offers = JSON.parse(offers_serialized)
      fail unless offers['results']
    rescue => e
      puts "***** An error occurred call_api with message #{e.message}: retrying in 5 seconds - jobkey: #{jobkey}*****"
      sleep 2
      retry
    end
    return offers['results']
  end

  def update_infos(job_offer)
    result = call_api_getjob(job_offer.jobkey).first
    if result
      args = {
        description_additional: result['snippet'],
        url_source_original: result['url'],
        expired: result['expired']
      }
      job_offer.update(args)
    end
  end

  def create_job_offers(offer, category)
    puts "creating job: #{offer["jobtitle"]} for company: #{offer["company"]}"
    args = {
      title: offer["jobtitle"],
      company: find_or_create_company(offer["company"]),
      category: category,
      description: offer["snippet"],
      formatted_location: offer["formattedLocation"],
      city: offer["city"],
      country: offer["country"],
      date: DateTime.parse(offer["date"]),
      source_primary: "indeed",
      source_original: offer["source"],
      url_source_primary: offer["url"],
      jobkey: offer["jobkey"]
    }
    job = JobOffer.create(args)
  end

  def find_or_create_company(name)
    if company = Company.find_by_name(name)
      puts "Company: #{name} exist !!!"
      return company
    else
      puts "Company: #{name} doesn't exist yet. Let's create it."
      return company = Company.create(name: name)
    end
  end

end
