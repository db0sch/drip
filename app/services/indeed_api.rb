require 'json'
require 'open-uri'

class IndeedApi

  def initialize(attributes = {})
    @publisher_key = attributes[:publisher_key]
  end

  def search_jobs(category, location, limit)
    url = "http://api.indeed.com/ads/apisearch?publisher=#{@publisher_key}&q=#{category.name}&l=#{location[:city]}&sort=&radius=&st=&jt=&start=&limit=#{limit}&fromage=&filter=&latlong=1&co=#{location[:country]}&format=json&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
    offers_serialized = open(url).read
    offers = JSON.parse(offers_serialized)
    fail unless offers['results']
    offers['results']
  end

  def get_job(jobkey)
    # call the Indeed get job API
    url = "http://api.indeed.com/ads/apigetjobs?publisher=#{@publisher_key}&jobkeys=#{jobkey}&v=2&format=json"
    offer_serialized = open(url).read
    offer = JSON.parse(offer_serialized)
    fail unless offer['results']
    return offer['results'].empty? ? {} : offer['results'].first
  end

end
