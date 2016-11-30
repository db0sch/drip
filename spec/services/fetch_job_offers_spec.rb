RSpec.describe "FetchJobOffers" do
  let(:api) { IndeedApi.new(publisher_key: ENV['indeed_publisher_key']) }
  let(:category) { Category.new(name: "livreur") }

  subject {
    FetchJobOffers.new(api,
      categories: [category],
      locations: [{city: "paris", country: "fr"}],
      limit: 10
    )
  }

  it "should have an api instance" do
    expect(subject.api).to be_a(IndeedApi)
  end

  it "should return an array" do
    expect(subject.run).to be_a(Array)
  end

  # IDEAS FOR TEST
  # Should throw an error if no api is provided

end
