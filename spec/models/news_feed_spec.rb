require 'rails_helper'

RSpec.describe NewsFeed, type: :model do
  describe 'test associations and validations' do
    let(:news_feed) { build_stubbed(:news_feed) }

    it { expect(news_feed).to have_many(:news_feed_links).dependent(:destroy) }
    it { expect(news_feed).to have_many(:additional_news_feed_links).class_name('SharedNewsFeedLink').source(:news_feed) }
    it { expect(news_feed).to have_many(:shared_news_feed_links).through(:additional_news_feed_links).source(:news_feed_link) }

    it { expect(news_feed).to belong_to(:group) }
    it { expect(news_feed).to validate_presence_of(:group_id) }
  end

  describe 'test singleton methods' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise_id: enterprise.id) }
    let!(:group_message) { create(:group_message, group_id: group.id) }
    let!(:news_link) { create(:news_link, group_id: group.id) }
    let!(:social_link) { create(:social_link, group_id: group.id) }

    describe '.all_links' do
      context 'when segments are present' do
        let!(:segment) { create(:segment, enterprise_id: enterprise.id) }
        let!(:news_link_segment) { create(:news_link_segment, segment_id: segment.id,
                                                              news_link_id: news_link.id)
        }
        it 'returns news_feed_links' do
          expect(group.news_feed.all_links([segment].map(&:id)).count)
          .to eq(2)
        end
      end

      context 'when segment are absent' do
        it 'returns news_feed_links' do
          expect(group.news_feed.all_links_without_segments.count)
          .to eq(2)
        end
      end
    end

    describe '.all_links_without_segments' do
      context 'when social media is enabled' do
        before {
          enterprise.update_column(:enable_social_media, true)
          group.reload
        }

        it 'returns all links without segments' do
          expect(group.news_feed.all_links_without_segments.count)
          .to eq(3)
        end
      end

      context 'when social media is disabled' do
        it 'returns all links without segments' do
          expect(group.news_feed.all_links_without_segments.count)
          .to eq(2)
        end
      end
    end

    describe '.archived_posts' do
      before { NewsFeedLink.where(group_message_id: group_message.id).update_all(archived_at: Time.now) }

      it 'returns archived posts for an enterprise' do
        expect(described_class.archived_posts(enterprise)).to eq([group_message.news_feed_link])
      end
    end
  end
  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      news_feed = create(:news_feed)
      news_feed_link = create(:news_feed_link, news_feed: news_feed)

      news_feed.destroy

      expect { NewsFeed.find(news_feed.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsFeedLink.find(news_feed_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
