require 'rails_helper'

RSpec.describe NewsFeedLinkSegment, type: :model do
    describe 'validations' do
        let(:news_feed_link_segment) { FactoryGirl.build_stubbed(:news_feed_link_segment) }

        it{ expect(news_feed_link_segment).to validate_presence_of(:news_feed_link) }
        it{ expect(news_feed_link_segment).to validate_presence_of(:segment) }
        it{ expect(news_feed_link_segment).to validate_presence_of(:link_segment) }
        
        it { expect(news_feed_link_segment).to belong_to(:news_feed_link) }
        it { expect(news_feed_link_segment).to belong_to(:segment) }
        it { expect(news_feed_link_segment).to belong_to(:link_segment) }
    end
end
