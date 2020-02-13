require 'rails_helper'

RSpec.describe NewsFeedLink, type: :model do
  include ActiveJob::TestHelper

  describe 'tests associations and validations' do
    let(:news_feed_link) { build_stubbed(:news_feed_link) }

    it { expect(news_feed_link).to belong_to(:news_feed) }
    it { expect(news_feed_link).to belong_to(:news_link).dependent(:delete) }
    it { expect(news_feed_link).to belong_to(:group_message).dependent(:delete) }
    it { expect(news_feed_link).to belong_to(:social_link).dependent(:delete) }

    it { expect(news_feed_link).to have_many(:news_feed_link_segments).dependent(:destroy) }
    it { expect(news_feed_link).to have_many(:segments).through(:news_feed_link_segments) }
    it { expect(news_feed_link).to have_many(:shared_news_feed_links).class_name('SharedNewsFeedLink').dependent(:destroy) }
    it { expect(news_feed_link).to have_many(:shared_news_feeds).through(:shared_news_feed_links) }
    it { expect(news_feed_link).to have_many(:views).dependent(:destroy) }
    it { expect(news_feed_link).to have_many(:likes).dependent(:destroy) }

    it { expect(news_feed_link).to delegate_method(:group).to(:news_feed) }

    it { expect(news_feed_link).to validate_presence_of(:news_feed_id) }
  end

  describe 'test scopes' do
    describe '.approved' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, enterprise_id: enterprise.id) }
      before { create_list(:group_message, 2, group_id: group.id) }

      it 'returns approved news_feed_links' do
        expect(NewsFeedLink.approved.count).to eq(2)
      end
    end

    describe '.not_approved' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, enterprise_id: enterprise.id) }
      let!(:group2) { create(:group, enterprise_id: enterprise.id) }
      before do
        group_messages = create_list(:group_message, 3, group_id: group.id)
        group_messages2 = create_list(:group_message, 3, group_id: group2.id)
        NewsFeedLink.where(group_message_id: group_messages.map(&:id)).update_all(approved: false)
        NewsFeedLink.where(group_message_id: group_messages2.map(&:id)).update_all(approved: false)
      end

      it 'returns not_approved news_feed_links' do
        expect(NewsFeedLink.not_approved.count).to eq(6)
      end

      it 'returns not_approved for particular feed news_feed_links' do
        expect(NewsFeedLink.not_approved(group.news_feed.id).count).to eq(3)
      end
    end

    describe '.combined_news_links' do
      let!(:enterprise) { create(:enterprise) }
      let!(:group) { create(:group, enterprise_id: enterprise.id) }
      before do
        create(:group_message, group_id: group.id)
        create(:news_link, group_id: group.id)
        create(:social_link, group_id: group.id)
      end

      describe 'when social media is enabled' do
        before {
          enterprise.update_column(:enable_social_media, true)
          group.reload
        }

        it 'returns combined news links of a particular news feed' do
          expect(NewsFeedLink.combined_news_links(group.news_feed.id, group.enterprise).count).to eq(3)
        end
      end

      it 'returns combined news links of a particular news feed' do
        expect(NewsFeedLink.combined_news_links(group.news_feed.id, group.enterprise).count).to eq(2)
      end
    end
  end

  describe 'test callback' do
    let!(:news_feed_link) { build(:news_feed_link) }

    it '#approve_link' do
      expect(news_feed_link).to receive(:approve_link)
      news_feed_link.save
    end
  end

  describe '#approve_link' do
    it 'approves the link' do
      # ensure the job is performed and that
      # we don't receive any errors
      perform_enqueued_jobs do
        news_feed_link = build(:news_feed_link)
        news_feed_link.save

        expect(news_feed_link.approved).to eq(true)
      end
    end
  end

  describe 'view count functionality' do
    let(:news_feed_link) { create(:news_feed_link) }
    let(:user) { create(:user) }

    it 'creates a valid view on increment' do
      news_feed_link.increment_view(user)

      expect(news_feed_link.views.last.user_id).to eq(user.id)
    end

    it 'increments an existing view' do
      news_feed_link.increment_view(user)
      view = news_feed_link.views.last
      news_feed_link.increment_view(user)

      expect(news_feed_link.views.last.id).to eq(view.id)
    end

    it 'returns total views' do
      news_feed_link.increment_view(user)
      expect(news_feed_link.total_views).to eq(1)
    end

    it 'returns unquie views' do
      news_feed_link.increment_view(user)
      expect(news_feed_link.unique_views).to eq(1)
    end

    it '#create_view_if_none' do
      expect { news_feed_link.create_view_if_none(user) }.to change(View, :count).by(1)
    end
  end

  describe '#link' do
    it 'returns group_message' do
      group_message = create(:group_message)
      news_feed_link = group_message.news_feed_link
      expect(news_feed_link.link).to eq(group_message)
    end

    it 'returns news_link' do
      news_link = create(:news_link)
      news_feed_link = news_link.news_feed_link
      expect(news_feed_link.link).to eq(news_link)
    end

    it 'returns social link' do
      social_link = create(:social_link)
      news_feed_link = social_link.news_feed_link
      expect(news_feed_link.link).to eq(social_link)
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      news_feed_link = create(:news_feed_link)
      segment = create(:news_feed_link_segment, news_feed_link: news_feed_link)

      news_feed_link.destroy

      expect { NewsFeedLink.find(news_feed_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsFeedLinkSegment.find(segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'removes associated parent object' do
      news_feed_link = create(:news_feed_link, social_link_id: create(:social_link).id)

      news_feed_link.destroy

      expect { SocialLink.find(news_feed_link.social_link_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.archive_expired_news' do
    let!(:group) { create(:group) }
    let!(:new_items) { create_list(:news_feed_link, 3, news_feed: group.news_feed) }
    let!(:expired_news_items) { create_list(:news_feed_link, 2, news_feed: group.news_feed, created_at: Time.now.weeks_ago(1), updated_at: Time.now.weeks_ago(1)) }

    it 'archives nothing if auto_archive is off' do
      expect { NewsFeedLink.archive_expired_news(group) }.to change(NewsFeedLink.where.not(archived_at: nil), :count).by(0)
    end

    it 'archives expired news items when auto_archive is on' do
      group.update(unit_of_expiry_age: 'weeks', expiry_age_for_news: 1, auto_archive: true)
      expect { NewsFeedLink.archive_expired_news(group) }.to change(NewsFeedLink.where.not(archived_at: nil), :count).by(2)
    end
  end
end
