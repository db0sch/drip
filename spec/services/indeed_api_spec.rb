require 'rails_helper'

RSpec.describe "IndeedApi", type: :service do
  let(:category1) { Category.new(name:"livreur") }
  let(:category2) { Category.new(name:"hotesse") }
  let(:category3) { Category.new(name:"extra") }

  subject {
    IndeedApi.new(
      publisher_key: ENV['indeed_publisher_key'],
      categories: [category1, category2, category3],
    )
  }

  describe
end


# must test the private methods as well.
# For this, use instace_eval
