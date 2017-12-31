require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    include ActiveJob::TestHelper

    let!(:user) { create :user }
    let!(:group) { create(:group, enterprise: user.enterprise, owner: user) }
    let!(:news_feed) { create(:news_feed, group: group) }
    let!(:news_feed_link1) { create(:news_feed_link, link: news_link1, news_feed: news_feed, approved: true, created_at: Time.now - 5.hours) }
    let!(:news_feed_link2) { create(:news_feed_link, link: news_link2, news_feed: news_feed, approved: true, created_at: Time.now - 2.hours) }
    let!(:news_feed_link3) { create(:news_feed_link, link: news_link3, news_feed: news_feed, approved: true, created_at: Time.now) }
    let!(:news_link1) { create(:news_link, :group => group)}
    let!(:news_link2) { create(:news_link, :group => group)}
    let!(:news_link3) { create(:news_link, :group => group)}


    describe 'GET #index' do
        context 'with user logged in' do
            login_user_from_let
            before { get :index, group_id: group.id }

            it 'render index template' do
                expect(response).to render_template :index
            end

            describe 'policy(@group).erg_leader_permissions? returns true' do
                let!(:group_leader) { create(:group_leader, user: user, group: group, visible: true, notifications_enabled: false) }

                it 'return count 3' do
                    expect(assigns[:count]).to eq 3
                end

                it 'return 3 posts' do 
                    expect(assigns[:posts].count).to eq 3
                end
            end

            describe 'if current user' do
                let!(:segment) { create(:segment, enterprise: user.enterprise, owner: user) }
                let!(:news_link4) { create(:news_link, :group => group)}
                let!(:news_feed_link4) { create(:news_feed_link, link: news_link4, news_feed: news_feed, approved: true, created_at: Time.now - 3.hours) }
                let!(:news_link_segment) { create(:news_link_segment, segment: segment, news_link: news_link4) }
                let!(:news_feed_link_segment) { create(:news_feed_link_segment, segment: segment, news_feed_link: news_feed_link4, link_segment: news_link_segment ) }
                let!(:base_query) { group.news_feed_links.approved }
                
                
                context 'is an active member of group' do 
                    let!(:user_group) { create(:user_group, user: user, group: group) }
                    

                    it 'return 4 posts' do
                        expect(assigns[:posts].count).to eq 4
                    end
                end

                context 'is not an active member of group' do
                    it 'returns 0 counts' do 
                        allow(group.active_members).to receive(:include?).with(user).and_return(false)
                        byebug
                    end
                end
            end
        end
    end


    describe 'GET #pending' do
        it 'return success' do
            get :pending, group_id: group.id
            expect(response).to be_success
        end
    end

    describe 'PATCH #approve' do
        before :each do
            # ensure the job is performed and that
            # we don't receive any errors
            perform_enqueued_jobs do
                request.env["HTTP_REFERER"] = "back"
                patch :approve, group_id: group.id, link_id: news_link.news_feed_link.id
            end
        end

        it 'return success' do
            expect(response).to redirect_to "back"
        end
    end
end
