require 'rails_helper'

RSpec.describe MentorshipSession, :type => :model do

    describe 'validations' do
        let(:mentorship_session) { FactoryGirl.build_stubbed(:mentorship_session) }

        it{ expect(mentorship_session).to validate_presence_of(:user) }
        it{ expect(mentorship_session).to validate_presence_of(:mentoring_session) }
        
        it { expect(mentorship_session).to belong_to(:user) }
        it { expect(mentorship_session).to belong_to(:mentoring_session) }
    end
end