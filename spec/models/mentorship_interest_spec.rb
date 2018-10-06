require 'rails_helper'

RSpec.describe MentorshipInterest, :type => :model do

    describe 'validations' do
        let(:mentorship_interest) { FactoryGirl.build_stubbed(:mentorship_interest) }

        it{ expect(mentorship_interest).to validate_presence_of(:user) }
        it{ expect(mentorship_interest).to validate_presence_of(:mentoring_interest) }
        
        it { expect(mentorship_interest).to belong_to(:user) }
        it { expect(mentorship_interest).to belong_to(:mentoring_interest) }
    end
end