require 'rails_helper'

RSpec.describe NewsLinkSegment, type: :model do
    
    describe 'validations' do
        let(:news_link_segment) { FactoryGirl.build_stubbed(:news_link_segment) }

        it{ expect(news_link_segment).to validate_presence_of(:news_link_id) }
        it{ expect(news_link_segment).to validate_presence_of(:segment_id) }
        
        it { expect(news_link_segment).to belong_to(:news_link) }
        it { expect(news_link_segment).to belong_to(:segment) }
    end
end
