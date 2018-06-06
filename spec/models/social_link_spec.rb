require 'rails_helper'

RSpec.describe SocialLink, type: :model do

    describe 'validation' do
        let(:social_link) { FactoryGirl.build_stubbed(:social_link) }

        it 'has valid factory' do
            expect(social_link).to be_valid
        end

        it{ expect(social_link).to validate_presence_of(:author_id) }

        it{ expect(social_link).to have_many(:segments).through(:social_link_segments) }

        it { expect(social_link).to have_one(:news_feed_link)}

        describe 'url population' do
            let(:social_link) { build :social_link, :without_embed_code}

            context 'with correct url' do
                before { social_link.save }

                it 'creates new instance' do
                    expect(social_link).to be_persisted
                    expect(social_link).to be_valid
                end

                it 'populates embed code' do
                    expect(social_link.embed_code).to_not be_empty
                end
            end

            context 'with incorrect url' do
                before do
                    social_link.url = 'https://blahblah.rb/deffdsieh'
                    social_link.save
                end

                it 'does not populate embed code' do
                    expect(social_link.embed_code).to be_nil
                end

                it 'adds error message' do
                    expect(social_link).to_not be_valid
                    expect(social_link.errors[:url]).to include('is not a valid url for supported services')
                end
            end
        end
    end

    describe "#after_create" do
        it "calls callbacks and creates attributes/association" do
            social_link = build(:social_link)
            social_link.save

            expect(social_link.embed_code).to_not be(nil)
            expect(social_link.news_feed_link).to_not be(nil)
            expect(social_link.url[-1]).to eq("/")
        end
    end

    describe "#url_safe" do
        it "returns" do
            social_link = create(:social_link)
            expect(social_link.url_safe).to eq(CGI.escape(social_link.url))
        end
    end

    describe "#remove_segment_association" do
        it "removes segment association" do
            social_link = create(:social_link)
            segment = create(:segment)

            social_link.segment_ids = [segment.id]
            social_link.save

            expect(social_link.segments.length).to eq(1)
            expect(social_link.social_link_segments.length).to eq(1)

            social_link_segment = social_link.social_link_segments.where(:segment_id => segment.id).first

            expect(social_link_segment.news_feed_link_segment).to_not be(nil)

            social_link.remove_segment_association(segment)

            expect(social_link_segment.news_feed_link_segment).to_not be(nil)

        end
    end

    describe ".of_segments" do
        it "returns 0 social links" do
            user = create(:user)
            social_link_1 = create(:social_link)
            social_link_2 = create(:social_link)
            segment = create(:segment)

            social_link_1.segment_ids = [segment.id]
            social_link_1.save

            social_link_2.segment_ids = [segment.id]
            social_link_2.save

            expect(user.segments.length).to eq(0)

            expect(SocialLink.of_segments(user.segments.pluck(:id)).count).to eq(0)
        end

        it "returns 1 social link" do
            user = create(:user)
            social_link = create(:social_link, :author => user)
            segment = create(:segment)

            expect(social_link.segments.length).to eq(0)
            expect(social_link.social_link_segments.length).to eq(0)

            social_link.segment_ids = [segment.id]
            social_link.save

            expect(social_link.segments.length).to eq(1)
            expect(social_link.social_link_segments.length).to eq(1)

            expect(user.segments.length).to eq(0)

            user.segments << segment

            expect(user.segments.length).to eq(1)

            expect(SocialLink.of_segments(user.segments.pluck(:id)).count).to eq(1)
        end

        it "returns 1 social link when user is member of group" do
            user = create(:user)
            group = create(:group)
            social_link = create(:social_link, :author => user, :group => group)
            segment = create(:segment)

            expect(social_link.segments.length).to eq(0)
            expect(social_link.social_link_segments.length).to eq(0)

            social_link.segment_ids = [segment.id]
            social_link.save

            expect(social_link.segments.length).to eq(1)
            expect(social_link.social_link_segments.length).to eq(1)

            expect(user.segments.length).to eq(0)

            user.segments << segment

            expect(user.segments.length).to eq(1)

            user.groups << group

            expect(user.groups.length).to eq(1)

            expect(SocialLink.where(group: group).of_segments(user.segments.pluck(:id)).count).to eq(1)
        end

        it "returns 0 social link even when user is member of group" do
            user = create(:user)
            group = create(:group)
            social_link = create(:social_link, :author => user, :group => group)
            segment = create(:segment)

            expect(social_link.segments.length).to eq(0)
            expect(social_link.social_link_segments.length).to eq(0)

            social_link.segment_ids = [segment.id]
            social_link.save

            expect(social_link.segments.length).to eq(1)
            expect(social_link.social_link_segments.length).to eq(1)

            expect(user.segments.length).to eq(0)

            user.groups << group

            expect(user.groups.length).to eq(1)

            expect(SocialLink.where(group: group).of_segments(user.segments.pluck(:id)).count).to eq(0)
        end

        it "returns 2 social links" do
            user = create(:user)
            social_link_1 = create(:social_link, :author => user)
            social_link_2 = create(:social_link, :author => user)
            segment = create(:segment)

            social_link_1.segment_ids = [segment.id]
            social_link_1.save

            social_link_2.segment_ids = [segment.id]
            social_link_2.save

            user.segments << segment

            expect(user.segments.length).to eq(1)

            expect(SocialLink.of_segments(user.segments.pluck(:id)).count).to eq(2)
        end
    end
    
    describe "#destroy_callbacks" do
        it "removes the child objects" do
          social_link = create(:social_link)
          news_feed_link = social_link.news_feed_link
          social_link_segment = create(:social_link_segment, :social_link => social_link)
          user_reward_action = create(:user_reward_action, :social_link => social_link)
    
          social_link.destroy
    
          expect{SocialLink.find(social_link.id)}.to raise_error(ActiveRecord::RecordNotFound)
          expect{NewsFeedLink.find(news_feed_link.id)}.to raise_error(ActiveRecord::RecordNotFound)
          expect{SocialLinkSegment.find(social_link_segment.id)}.to raise_error(ActiveRecord::RecordNotFound)
          expect{UserRewardAction.find(user_reward_action)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end
