require 'rails_helper'

RSpec.describe NewsLinkSegment, type: :model do
  describe 'validations' do
    let(:news_link_segment) { build_stubbed(:news_link_segment) }

    it { expect(news_link_segment).to validate_presence_of(:news_link_id).on(:save) }
    it { expect(news_link_segment).to validate_presence_of(:segment_id).on(:save) }

    it { expect(news_link_segment).to belong_to(:news_link) }
    it { expect(news_link_segment).to belong_to(:segment) }

    it { expect(news_link_segment).to have_one(:news_feed_link_segment).dependent(:destroy) }
  end

  describe '#news_feed_link_segment' do
    it 'has default news_feed_link_segment' do
      news_link_segment = create(:news_link_segment)
      expect(news_link_segment.news_feed_link_segment).to_not be_nil
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      news_link_segment = create(:news_link_segment)
      news_feed_link_segment = create(:news_feed_link_segment, news_link_segment: news_link_segment)

      news_link_segment.destroy

      expect { NewsLinkSegment.find(news_link_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsFeedLinkSegment.find(news_feed_link_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
