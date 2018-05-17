require 'rails_helper'

RSpec.describe NewsFeed, type: :model do

    describe 'validations' do
        let(:news_feed) { FactoryGirl.build_stubbed(:news_feed) }

        it{ expect(news_feed).to validate_presence_of(:group_id) }
        it { expect(news_feed).to belong_to(:group) }
        it { expect(news_feed).to have_many(:news_feed_links) }
    end

    describe "#destroy_callbacks" do
      it "removes the child objects" do
        news_feed = create(:news_feed)
        news_feed_link = create(:news_feed_link, :news_feed => news_feed)

        news_feed.destroy

        expect{NewsFeed.find(news_feed.id)}.to raise_error(ActiveRecord::RecordNotFound)
        expect{NewsFeedLink.find(news_feed_link.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
end
