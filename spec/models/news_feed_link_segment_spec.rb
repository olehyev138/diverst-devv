require 'rails_helper'

RSpec.describe NewsFeedLinkSegment, type: :model do
  describe 'validations' do
    let(:news_feed_link_segment) { build_stubbed(:news_feed_link_segment) }

    it { expect(news_feed_link_segment).to belong_to(:news_feed_link) }
    it { expect(news_feed_link_segment).to belong_to(:segment) }
    it { expect(news_feed_link_segment).to belong_to(:news_link_segment) }
    it { expect(news_feed_link_segment).to belong_to(:group_messages_segment) }
    it { expect(news_feed_link_segment).to belong_to(:social_link_segment) }
  end
end
