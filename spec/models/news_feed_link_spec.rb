require 'rails_helper'

RSpec.describe NewsFeedLink, type: :model do
    describe 'validations' do
        let(:news_feed_link) { FactoryGirl.build_stubbed(:news_feed_link) }

        it{ expect(news_feed_link).to validate_presence_of(:news_feed_id) }
        it{ expect(news_feed_link).to validate_presence_of(:link_id) }
        it{ expect(news_feed_link).to validate_presence_of(:link_type) }
        
        it { expect(news_feed_link).to belong_to(:news_feed) }
        it { expect(news_feed_link).to belong_to(:link) }
    end
end
