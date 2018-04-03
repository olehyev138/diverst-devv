require 'rails_helper'

RSpec.describe MentoringRequest, :type => :model do

    describe 'validations' do
        let(:mentoring_request) { FactoryGirl.build_stubbed(:mentoring_request) }

        it{ expect(mentoring_request).to validate_presence_of(:type) }
        it{ expect(mentoring_request).to validate_presence_of(:sender) }
        it{ expect(mentoring_request).to validate_presence_of(:receiver) }
    end
end