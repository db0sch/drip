require 'json'
require 'open-uri'

class IndeedApi

  def initialize(attributes = {})
    @publisher_key = attributes[:publisher_key]
    @categories = attributes[:categories]
    @locations = attributes[:locations] || [["paris", "fr"]]
  end

  def get_jobs
    # iterate on @categories & locations
    # call the api with parameter, for each category
    @categories.each do |category|
      @locations.each do |location|
        call_api(category.name, location)
      end
    end
    # create a job_offer instace for each result
    # return something (true?)
    # handle error with raise and begin
  end

  private

  def call_api(category, location)
    params = {
      category: category,
      city: location[0],
      country: location[1],
      limit: 9,
    }

    url = "http://api.indeed.com/ads/apisearch?publisher=#{@publisher_key}&q=#{params[:category]}&l=#{params[:city]}&sort=&radius=&st=&jt=&start=&limit=#{params[:limit]}&fromage=&filter=&latlong=1&co=#{params[:country]}&format=json&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
    offers_serialized = open(url).read
    offers = JSON.parse(offers_serialized)
    p offers
  end

end
