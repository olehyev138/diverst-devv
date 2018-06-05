require 'rails_helper'

RSpec.describe NewsFeedLink, type: :model do
    include ActiveJob::TestHelper

    describe 'validations' do
        let(:news_feed_link) { FactoryGirl.build_stubbed(:news_feed_link) }

        it{ expect(news_feed_link).to validate_presence_of(:news_feed_id) }

        it { expect(news_feed_link).to belong_to(:news_feed) }
        it { expect(news_feed_link).to belong_to(:news_link) }
        it { expect(news_feed_link).to belong_to(:group_message) }
        it { expect(news_feed_link).to belong_to(:social_link) }

        it { expect(news_feed_link).to have_many(:news_feed_link_segments) }
        it { expect(news_feed_link).to delegate_method(:group).to(:news_feed) }
    end

    describe "#approve_link" do
        it "approves the link" do
            # ensure the job is performed and that
            # we don't receive any errors
            author = create(:user)
            author.policy_group.groups_manage = true
            author.policy_group.save!

            link = create(:news_link, :author => author)

            perform_enqueued_jobs do
                news_feed_link = build(:news_feed_link, :news_link => link)
                news_feed_link.save

                expect(news_feed_link.approved).to eq(true)
            end
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
    end
end
