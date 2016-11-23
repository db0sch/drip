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
    # create a job_offer instace for each result
    results_by_category.each do |category, results|
      results.each do |result|
        job_offer_instances(result, category)
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

  def job_offer_instances(offer, category)

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
      # url_source_primary: offer["url"],
      jobkey: offer["jobkey"]
    }
    # start_date: ,
    # new instance variable ==> Migration needed.
    # description_additional: ,
    # url_source_original:

    job = JobOffer.new(args)
    p "JobOffer: #{job.title} is valid!" if job.valid?
    job.save
  end

  def find_or_create_company(name)
    if company = Company.find_by_name(name)
      return company
    else
      return company = Company.create(name: name)
    end
  end

end
