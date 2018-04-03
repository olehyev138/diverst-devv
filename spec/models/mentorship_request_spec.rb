require 'rails_helper'

RSpec.describe MentorshipRequest, :type => :model do

    describe 'validations' do
        let(:mentorship_request) { FactoryGirl.build_stubbed(:mentorship_request) }

        it{ expect(mentorship_request).to validate_presence_of(:mentorship) }
        it{ expect(mentorship_request).to validate_presence_of(:mentoring_request) }
        
        it { expect(mentorship_request).to belong_to(:mentorship) }
        it { expect(mentorship_request).to belong_to(:mentoring_request) }
    end
end