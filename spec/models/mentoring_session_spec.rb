require 'rails_helper'

RSpec.describe MentoringSession, :type => :model do

    describe 'validations' do
        let(:mentoring_session) { FactoryGirl.build_stubbed(:mentoring_session) }

        it{ expect(mentoring_session).to validate_presence_of(:start) }
        it{ expect(mentoring_session).to validate_presence_of(:end) }
        it{ expect(mentoring_session).to validate_presence_of(:status) }
    end
end