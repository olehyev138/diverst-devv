require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    include ActiveJob::TestHelper


    describe 'GET #index' do
        let!(:group) { create(:group, enterprise: user.enterprise, owner: user) }
        let!(:news_feed) { create(:news_feed, group: group) }
        let!(:news_feed_link1) { create(:news_feed_link, link: news_link1, news_feed: news_feed, approved: true, created_at: Time.now - 5.hours) }
        let!(:news_feed_link2) { create(:news_feed_link, link: news_link2, news_feed: news_feed, approved: true, created_at: Time.now - 2.hours) }
        let!(:news_feed_link3) { create(:news_feed_link, link: news_link3, news_feed: news_feed, approved: true, created_at: Time.now) }
        let!(:news_link1) { create(:news_link, :group => group)}
        let!(:news_link2) { create(:news_link, :group => group)}
        let!(:news_link3) { create(:news_link, :group => group)}

        describe 'with user logged in' do
            let!(:user) { create :user }
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
        
        context "when user is not admin but a group member" do
            let(:policy_group){create(:policy_group, :groups_manage => false)}
            let(:user) { create :user, :policy_group => policy_group, :active => true}
            let(:group) { create(:group, enterprise: user.enterprise) }
            let!(:user_group) { create(:user_group, :accepted_member => true, :group => group, :user => user) }
            let(:news_link) { create(:news_link, :group => group)}
            
            login_user_from_let
            
            before{
                news_link.news_feed_link.approved = true
                news_link.news_feed_link.save!
                get :index, group_id: group.id
            }
            
            it 'render index template' do
                expect(response).to render_template :index
            end
            
            it "assigns 1 count" do 
                expect(assigns[:count]).to eq 4
            end
        end
        
        context "when user is not admin and group member" do
            let(:policy_group){create(:policy_group, :groups_manage => false)}
            let(:user) { create :user, :policy_group => policy_group}
            let(:group) { create(:group, enterprise: user.enterprise) }
            let(:news_link) { create(:news_link, :group => group)}
            
            login_user_from_let
            
            before{get :index, group_id: group.id}
            
            it 'render index template' do
                expect(response).to render_template :index
            end
            
            it "assigns 0 count" do 
                expect(assigns[:count]).to eq 0
            end
        end

            describe 'if current user' do
                let!(:segment) { create(:segment, enterprise: user.enterprise, owner: user) }
                let!(:news_link4) { create(:news_link, :group => group)}
                let!(:news_feed_link4) { create(:news_feed_link, link: news_link4, news_feed: news_feed, approved: true, created_at: Time.now - 3.hours) }
                let!(:news_link_segment) { create(:news_link_segment, segment: segment, news_link: news_link4) }
                let!(:news_feed_link_segment) { create(:news_feed_link_segment, segment: segment, news_feed_link: news_feed_link4, link_segment: news_link_segment ) }
                let!(:base_query) { group.news_feed_links.approved }
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
    end


    describe 'GET #pending' do
        login_user_from_let

        let!(:user) { create :user }
        let!(:group) { create(:group, enterprise: user.enterprise, owner: user) }
        let!(:news_feed) { create(:news_feed, group: group) }
        let!(:news_link1) { create(:news_link, :group => group)}
        let!(:news_link2) { create(:news_link, :group => group)}
        let!(:news_link3) { create(:news_link, :group => group)}
        let!(:news_link4) { create(:news_link, :group => group) }
        let!(:unapproved_news_feed_link) { create(:news_feed_link, link: news_link4, news_feed: news_feed, approved: true, created_at: Time.now - 4.hours) } 
        let!(:news_feed_link1) { create(:news_feed_link, link: news_link1, news_feed: news_feed, approved: true, created_at: Time.now - 4.hours) }
        let!(:news_feed_link2) { create(:news_feed_link, link: news_link2, news_feed: news_feed, approved: true, created_at: Time.now - 1.hours) }
        let!(:news_feed_link3) { create(:news_feed_link, link: news_link3, news_feed: news_feed, approved: true, created_at: Time.now) }

        
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


    describe 'PATCH #approve' do
        let!(:user) { create :user }
        let!(:group) { create(:group, enterprise: user.enterprise, owner: user) }
        let!(:news_feed) { create(:news_feed, group: group) }
        let!(:news_link1) { create(:news_link, :group => group)}
        let!(:news_link2) { create(:news_link, :group => group)}
        let!(:news_link3) { create(:news_link, :group => group)}
        let!(:news_feed_link1) { create(:news_feed_link, link: news_link1, news_feed: news_feed, approved: true, created_at: Time.now - 4.hours) }
        let!(:news_feed_link2) { create(:news_feed_link, link: news_link2, news_feed: news_feed, approved: true, created_at: Time.now - 1.hours) }
        let!(:news_feed_link3) { create(:news_feed_link, link: news_link3, news_feed: news_feed, approved: true, created_at: Time.now) }
        login_user_from_let

        
        context "when successful" do
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
        
        context "when unsuccessful" do
            before do
                request.env["HTTP_REFERER"] = "back"
                news_link1.news_feed_link.approved = false
                news_link1.news_feed_link.save!
                
                allow_any_instance_of(NewsFeedLink).to receive(:save).and_return(false)
                
                patch :approve, group_id: group.id, link_id: news_link1.news_feed_link.id
            end
            
            it 'flashes an alert message' do
                expect(flash[:alert]).to eq "Link not approved"
            end
        end
    end
end
