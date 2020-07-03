require 'rails_helper'

RSpec.describe SharedNewsFeedLink, type: :model do
  let(:shared_news_feed_link) { build(:shared_news_feed_link) }

  describe 'test associations' do
    it { expect(shared_news_feed_link).to belong_to(:news_feed_link) }
    it { expect(shared_news_feed_link).to belong_to(:news_feed) }
  end
end
