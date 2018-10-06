require 'rails_helper'

RSpec.describe MentoringRequestInterest, :type => :model do

    describe 'validations' do
        let(:mentoring_request_interest) { FactoryGirl.build_stubbed(:mentoring_request_interest) }

        it{ expect(mentoring_request_interest).to validate_presence_of(:mentoring_request) }
        it{ expect(mentoring_request_interest).to validate_presence_of(:mentoring_interest) }
    end
end