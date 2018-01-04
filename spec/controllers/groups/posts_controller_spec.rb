require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    include ActiveJob::TestHelper
    
    let(:user) { create :user }
    let(:group1) { create(:group, enterprise: user.enterprise) }
    let(:news_link1) { create(:news_link, :group => group1)}
    
    describe 'GET #index' do
        context "when user is admin" do
            let(:user) { create :user }
            let(:group1) { create(:group, enterprise: user.enterprise) }
            let(:news_link1) { create(:news_link, :group => group1)}
    
            login_user_from_let
            
            before{
                news_link1.news_feed_link.approved = true
                news_link1.news_feed_link.save!
                
                get :index, group_id: group1.id
            }
            
            it 'return success' do
                expect(response).to be_success
            end
            
            it "assigns 1 count" do 
                expect(assigns[:count]).to eq 1
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
            
            it 'return success' do
                expect(response).to be_success
            end
            
            it "assigns 1 count" do 
                expect(assigns[:count]).to eq 1
            end
        end
        
        context "when user is not admin and group member" do
            let(:policy_group){create(:policy_group, :groups_manage => false)}
            let(:user) { create :user, :policy_group => policy_group}
            let(:group) { create(:group, enterprise: user.enterprise) }
            let(:news_link) { create(:news_link, :group => group)}
            
            login_user_from_let
            
            before{get :index, group_id: group.id}
            
            it 'return success' do
                expect(response).to be_success
            end
            
            it "assigns 0 count" do 
                expect(assigns[:count]).to eq 0
            end
        end
    end
    
    describe 'GET #pending' do
        login_user_from_let
        
        it 'return success' do
            get :pending, group_id: group1.id
            expect(response).to be_success
        end
    end
    
    describe 'PATCH #approve' do
        login_user_from_let
        
        context "when successful" do
            before :each do
                # ensure the job is performed and that
                # we don't receive any errors
                perform_enqueued_jobs do
                    request.env["HTTP_REFERER"] = "back"
                    patch :approve, group_id: group1.id, link_id: news_link1.news_feed_link.id
                end
            end
            
            it 'return success' do
                expect(response).to redirect_to "back"
            end
        end
        
        context "when unsuccessful" do
            before :each do
                request.env["HTTP_REFERER"] = "back"
                news_link1.news_feed_link.approved = false
                news_link1.news_feed_link.save!
                
                allow_any_instance_of(NewsFeedLink).to receive(:save).and_return(false)
                
                patch :approve, group_id: group1.id, link_id: news_link1.news_feed_link.id
            end
            
            it 'flashes' do
                expect(flash[:alert]).to eq "Link not approved"
            end
        end
    end
end
