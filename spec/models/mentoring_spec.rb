require 'rails_helper'

RSpec.describe Mentoring, :type => :model do

    describe 'validations' do
        let(:mentoring) { FactoryGirl.build_stubbed(:mentoring) }

        it{ expect(mentoring).to validate_presence_of(:mentee) }
        it{ expect(mentoring).to validate_presence_of(:mentor) }

        it { expect(mentoring).to belong_to(:mentee) }
        it { expect(mentoring).to belong_to(:mentor) }
    end
end