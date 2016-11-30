class FetchJobOffers

  attr_reader :api, :categories, :locations, :limit, :companies

  def initialize(api, attributes = {})
    @api = api
    @categories = attributes[:categories] || Category.all.to_a
    @locations = attributes[:locations] || [{city: "paris", country: "fr"}]
    @limit = attributes[:limit] || 10
    @companies = Company.all.to_a
  end

  def run
    # call the api for each categories and location
    raw_results = call_api_for_all_params
    # reject all joboffers that exist in the database
    only_new_results = reject_existing_joboffers(raw_results)
    # iterate over these hashes and call the api update
    only_new_results.map! { |attributes| partial_update(attributes) }
    # create instances
    create_job_offers_instances_with only_new_results
  end

  private

  def reject_existing_joboffers(array_of_attributes)
    jobkeys = JobOffer.pluck(:jobkey)
    puts "let's take off the joboffer we already have!"
    array_of_attributes.reject do |attributes|
      jobkeys.include? attributes[:jobkey]
    end
  end

  def partial_update(attributes = {})
    result = @api.get_job(attributes[:jobkey])
    unless result.nil? || result.empty?
      puts "final update"
      attributes[:description_additional] = result['snippet']
      attributes[:url_source_original] = result['url']
      attributes[:expired] = result['expired']
      attributes
    end
  end

  def create_job_offers_instances_with(bunch_of_attributes)
    instances = []
    bunch_of_attributes.each do |attributes|
      joboffer = JobOffer.new(attributes)
      if joboffer.save
        instances << joboffer
      else
        puts "Job_offer #{joboffer.jobkey} has not been created because #{joboffer.errors.messages}"
      end
    end
    instances
  end

  def call_api_for_all_params
    results = @categories.map do |category|
      @locations.map do |location|
        puts "API call for location: #{location[:city]}, #{location[:country]} & category: #{category.name}"
        result = @api.search_jobs(category, location, @limit)
        creating_hash(result, category, location)
      end
    end
    results.flatten
  end

  def find_or_create_company(name)
    if company = @companies.find { |company| company.name == name }
      return company
    else
      company = Company.create(name: name)
      @companies << company
      return company
    end
  end

  def creating_hash(results,category,location)
    results.map do |result|
      attributes = {
        title: result["jobtitle"],
        company: find_or_create_company(result["company"]),
        description: result["snippet"],
        formatted_location: result["formattedLocation"],
        city: result["city"],
        country: result["country"],
        date: DateTime.parse(result["date"]),
        source_primary: "indeed",
        source_original: result["source"],
        url_source_primary: result["url"],
        jobkey: result["jobkey"],
        category: category
      }
    end
  end
end
