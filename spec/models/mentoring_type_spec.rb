require 'rails_helper'

RSpec.describe MentoringType, :type => :model do

    describe 'validations' do
        let(:mentoring_type) { FactoryGirl.build_stubbed(:mentoring_type) }

        it{ expect(mentoring_type).to validate_presence_of(:name) }
    end
end