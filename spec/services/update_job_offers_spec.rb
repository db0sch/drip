RSpec.describe "UpdateJobOffers" do
  let(:api) { IndeedApi.new(publisher_key: ENV['indeed_publisher_key']) }
  let(:category) { Category.new(name:"livreur") }
  let(:company) { Company.new(name:"enligne-fr") }
  let(:joboffer) { JobOffer.new(
      title:"Nous recrutons en CDI deux chauffeurs livreurs",
      description:"75000 Paris fr. Attention, si vous êtes stagiaire et
      que vous recherchez un stage, cliquez ici.",
      company: company,
      category: category,
      start_date: Date.today,
      jobkey: "425ee2469338da27"
    )
  }

  subject { UpdateJobOffers.new(api) }

  it "should have an api instance" do
    expect(subject.api).to be_a(IndeedApi)
  end

  describe "#check_expiry" do
    it "should return an array" do
      expect(subject.check_expiry).to be_a(Array)
    end
  end

  describe "#check_expiry_only_for" do
    it "should return a JobOffer instance" do
      joboffer_updated = subject.check_expiry_only_for(joboffer)
      expect(joboffer).to be_a(JobOffer)
    end
  end



  # IDEAS FOR TEST
  # Should throw an error if no api is provided

end
