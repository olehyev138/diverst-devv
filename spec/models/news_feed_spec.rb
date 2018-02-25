require 'rails_helper'

RSpec.describe NewsFeed, type: :model do

    describe 'validations' do
        let(:news_feed) { FactoryGirl.build_stubbed(:news_feed) }

        it{ expect(news_feed).to validate_presence_of(:group_id) }
        it { expect(news_feed).to belong_to(:group) }
        it { expect(news_feed).to have_many(:news_feed_links) }
    end
end
