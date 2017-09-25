require 'rails_helper'

RSpec.describe SocialLinkSegment, type: :model do
    describe 'validations' do
        let(:social_link_segment) { FactoryGirl.build_stubbed(:social_link_segment) }

        it{ expect(social_link_segment).to validate_presence_of(:social_link_id) }
        it{ expect(social_link_segment).to validate_presence_of(:segment_id) }
        
        it { expect(social_link_segment).to belong_to(:social_link) }
        it { expect(social_link_segment).to belong_to(:segment) }
    end
end
