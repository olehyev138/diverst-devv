require 'rails_helper'

RSpec.describe MentoringInterest, :type => :model do

    describe 'validations' do
        let(:mentoring_interest) { FactoryGirl.build_stubbed(:mentoring_interest) }

        it{ expect(mentoring_interest).to validate_presence_of(:name) }
    end
end