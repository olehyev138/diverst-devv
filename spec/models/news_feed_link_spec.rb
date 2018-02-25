require 'rails_helper'

RSpec.describe NewsFeedLink, type: :model do
    include ActiveJob::TestHelper

    describe 'validations' do
        let(:news_feed_link) { FactoryGirl.build_stubbed(:news_feed_link) }

        it{ expect(news_feed_link).to validate_presence_of(:news_feed_id) }
        it{ expect(news_feed_link).to validate_presence_of(:link_id) }
        it{ expect(news_feed_link).to validate_presence_of(:link_type) }

        it { expect(news_feed_link).to belong_to(:news_feed) }
        it { expect(news_feed_link).to belong_to(:link) }

        it { expect(news_feed_link).to have_many(:news_feed_link_segments) }
        it { expect(news_feed_link).to delegate_method(:group).to(:news_feed) }
        # it { expect(news_feed_link).to delegate_method(:segment).to(:news_feed_link_segment) }
    end

    describe "#approve_link" do
        it "approves the link" do
            # ensure the job is performed and that
            # we don't receive any errors
            perform_enqueued_jobs do
                news_feed_link = build(:news_feed_link)
                news_feed_link.save

                expect(news_feed_link.approved).to eq(true)
            end
        end
    end
end
