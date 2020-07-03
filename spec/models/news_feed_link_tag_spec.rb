require 'rails_helper'

RSpec.describe NewsFeedLinkTag, type: :model do
  describe 'validations' do
    let(:news_feed_link_tag) { build_stubbed(:news_feed_link_tag) }

    it { expect(news_feed_link_tag).to belong_to(:news_feed_link) }
    it { expect(news_feed_link_tag).to belong_to(:news_tag).with_foreign_key(:news_tag_name) }
  end
end
