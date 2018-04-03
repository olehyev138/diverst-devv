require 'rails_helper'

RSpec.describe Mentorship, :type => :model do

    describe 'validations' do
        let(:mentorship) { FactoryGirl.build_stubbed(:mentorship) }

        it{ expect(mentorship).to validate_presence_of(:user) }
        it{ expect(mentorship).to validate_presence_of(:description) }

        it { expect(mentorship).to belong_to(:user) }
    end
end