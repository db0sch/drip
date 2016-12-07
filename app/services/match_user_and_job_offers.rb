class MatchUserAndJobOffers
  def initialize(attributes)
    @user = attributes[:user]
    @joboffers = []
    @submissions = []
  end

  def process
    @user.job_preferences.each do |preference|
      category = preference.category
      find_joboffers(category)
    end
    @joboffers.each do |joboffer|
      create_submission_from joboffer
    end
  end

  private

  def find_joboffers(category)
    @joboffers = JobOffer.select_by_category(category)
    @joboffers.reject! do |joboffer|
      already_submitted?(@user, joboffer)
    end
  end

  def already_submitted?(user, joboffer)
    @user.job_offers.include?(joboffer)
  end

  def create_submission_from(joboffer)
    submission = Submission.new(user: @user, job_offer: joboffer)
    if submission.save
      @submissions << submission
    else
      puts "Submission #{submission.id} has not been created because #{submission.errors.messages}"
    end
  end

end
