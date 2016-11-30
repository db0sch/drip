RSpec.describe "IndeedApi" do
  let(:category1) { Category.new(name:"livreur") }
  let(:category3) { Category.new(name:"oidsqhjqsoij") }
  let(:location) { {city: "Paris", country: "fr"} }

  subject {
    IndeedApi.new(
      publisher_key: ENV['indeed_publisher_key'],
    )
  }

  # IDEAS FOR TEST
  # Should throw an error if no publisher_key
  # Should throw an error if no jobkey is '' (for get_job methods)

  describe '#search_jobs' do
    it "should return an Array" do
      results = subject.search_jobs(category1, location, 5)
      expect(results).to be_a(Array)
    end

    it "can return an empty array if no results" do
      results = subject.search_jobs(category3, location, 5)
      expect(results).to be_empty
    end

    it "should return an array with 5 element max. if limit is set to 5" do
      results = subject.search_jobs(category1, location, 5)
      expect(results.count).to be <= 5
    end
  end

  describe '#get_job' do
    it 'should return a Hash if we provide a jobkey' do
      jobkey = "3131cdd1783cf544"
      results = subject.get_job(jobkey)
      expect(results).to be_a(Hash)
    end

    it 'should return an empty Hash if jobkey is empty string' do
      jobkey = ''
      results = subject.get_job(jobkey)
      expect(results).to be_a(Hash)
    end

    it 'should return an empty Hash if jobkey is nil' do
      jobkey = nil
      results = subject.get_job(jobkey)
      expect(results).to be_a(Hash)
    end
  end
end
