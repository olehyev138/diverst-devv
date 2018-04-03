require 'rails_helper'

RSpec.describe MentorshipRating, :type => :model do

    describe 'validations' do
        let(:mentorship_rating) { FactoryGirl.build_stubbed(:mentorship_rating) }

        it{ expect(mentorship_rating).to validate_presence_of(:mentorship) }
        it{ expect(mentorship_rating).to validate_presence_of(:mentoring_session) }
        it{ expect(mentorship_rating).to validate_presence_of(:rating) }
        
        it { expect(mentorship_rating).to belong_to(:mentorship) }
        it { expect(mentorship_rating).to belong_to(:mentoring_session) }
    end
end