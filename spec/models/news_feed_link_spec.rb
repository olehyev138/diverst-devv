require 'rails_helper'

RSpec.describe NewsFeedLink, type: :model do
  include ActiveJob::TestHelper

  describe 'validations' do
    let(:news_feed_link) { FactoryGirl.build_stubbed(:news_feed_link) }

    it{ expect(news_feed_link).to validate_presence_of(:news_feed_id) }

    it { expect(news_feed_link).to belong_to(:news_feed) }
    it { expect(news_feed_link).to belong_to(:news_link).dependent(:destroy) }
    it { expect(news_feed_link).to belong_to(:group_message).dependent(:destroy) }
    it { expect(news_feed_link).to belong_to(:social_link).dependent(:destroy) }

    it { expect(news_feed_link).to have_many(:news_feed_link_segments) }
    it { expect(news_feed_link).to delegate_method(:group).to(:news_feed) }

    it { expect(news_feed_link).to have_many(:views) }
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
  end
  
  describe "#destroy_callbacks" do
    it "removes the child objects" do
      news_feed_link = create(:news_feed_link)
      segment = create(:news_feed_link_segment, :news_feed_link => news_feed_link)

      news_feed_link.destroy

      expect{NewsFeedLink.find(news_feed_link.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{NewsFeedLinkSegment.find(segment.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    it 'removes associated parent object' do 
      news_feed_link = create(:news_feed_link, social_link_id: create(:social_link).id)

      news_feed_link.destroy

      expect{SocialLink.find(news_feed_link.social_link_id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end