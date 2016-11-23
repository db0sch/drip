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
      results[category] = call_api_search(category.name)
    end
    # create a job_offer instace for each result
    results_by_category do |category, results|
      results.each do |result|
        job_instances(result, category)
      end
    end
    p "end"
    # return something (true?)
    # handle error with raise and begin
  end

  private

  def call_api_search(category)
    begin
      params = {
        category: category,
        city: @locations[0],
        country: @locations[1],
        limit: 2,
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

  def job_instances(offer, category)
    args = {
      title: offer["jobtitle"],
      # start_date: ,
      company: company_instace(offer["company"]),
      category: category,
      # new instance variable ==> Migration needed.
      description: offer["snippet"],
      # description_additional: ,
      formatted_location: offer["formattedLocation"],
      city: offer["city"],
      country: offer["country"]
      date: DateTime.parse(offer["date"]),
      source_primary: "indeed",
      source_original: offer["source"],
      url_source_primary: offer["url"],
      # url_source_original: ,
      jobkey: offer["jobkey"]
    }

    job = JobOffer.new(args)
    p "JobOffer: #{job.title} is valid!" if job.valid?
    job.save
  end

  def company_instance(name)
    # check if the company already exist
    # if yes, return the company instance
    # if no, create the new company instance
    # and return it
  end

end
