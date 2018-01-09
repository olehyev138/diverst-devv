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
        describe 'with user logged in' do
            login_user_from_let

            it 'render index template' do
                get :index, group_id: group.id
                expect(response).to render_template :index
            end

            context 'policy(@group).erg_leader_permissions? returns true' do
                let!(:group_leader) { create(:group_leader, user: user, group: group, visible: true, notifications_enabled: false) }

                it 'return count 3' do
                    get :index, group_id: group.id
                    expect(assigns[:count]).to eq 3
                end

                it 'return 3 posts' do
                    get :index, group_id: group.id
                    expect(assigns[:posts].count).to eq 3
                end
            end
        end

        describe 'if current user' do
            let!(:segment) { create(:segment, enterprise: user.enterprise, owner: user) }
            let!(:news_link4) { create(:news_link, :group => group)}
            let!(:news_feed_link4) { create(:news_feed_link, link: news_link4, news_feed: news_feed, approved: true, created_at: Time.now - 3.hours) }
            let!(:news_link_segment) { create(:news_link_segment, segment: segment, news_link: news_link4) }
            let!(:news_feed_link_segment) { create(:news_feed_link_segment, segment: segment, news_feed_link: news_feed_link4, link_segment: news_link_segment ) }
            let!(:user) { create :user }
            let!(:other_user) { create(:user) }
            let!(:other_group) { create(:group, enterprise: other_user.enterprise, owner: other_user) }


            context 'is an active member of group' do
                login_user_from_let
                let!(:user_group) { create(:user_group, user: user, group: group) }

                it 'returns count to be 4' do
                    get :index, group_id: group.id
                    expect(assigns[:count]).to eq 4
                end

                it 'return 4 posts' do
                    get :index, group_id: group.id
                    expect(assigns[:posts].count).to eq 4
                end
            end

            context 'is not an active member of group' do
                before { sign_in other_user }

                it 'returns 0 counts' do
                    get :index, group_id: other_group.id
                    expect(assigns[:count]).to eq 0
                end

                it 'returns posts as an empty array' do
                    get :index, group_id: other_group.id
                    expect(assigns[:posts]).to eq []
                end
            end
        end

        describe "without a logged in user" do
            before { get :index, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end


    describe 'GET #pending' do
        context 'when user is logged in' do
            login_user_from_let

            let!(:news_link4) { create(:news_link, :group => group) }
            let!(:unapproved_news_feed_link) { create(:news_feed_link, link: news_link4, news_feed: news_feed, approved: true, created_at: Time.now - 4.hours) }

            before do
                unapproved_news_feed_link.update(approved: false)
                group.news_feed_links << unapproved_news_feed_link
                get :pending, group_id: group.id
            end

            it 'render template' do
                expect(response).to render_template :pending
            end

            it 'return unapproved posts' do
                expect(assigns[:posts]).to eq [unapproved_news_feed_link]
            end
        end

        context 'when user is not logged in' do
            before { get :pending, group_id: group.id }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end

    describe 'PATCH #approve' do

        context 'when user is logged in' do
            login_user_from_let

            before do
            # ensure the job is performed and that
            # we don't receive any errors
            perform_enqueued_jobs do
                request.env["HTTP_REFERER"] = "back"
                patch :approve, group_id: group.id, link_id: news_link1.news_feed_link.id
            end
        end

          it 'redirect to back' do
              expect(response).to redirect_to "back"
          end
        end

        context 'when user is not logged in' do
            before { patch :approve, group_id: group.id, link_id: news_link1.news_feed_link.id}
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
