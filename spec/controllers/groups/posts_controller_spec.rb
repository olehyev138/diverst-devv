require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    let(:user) { create :user }
    let(:group) { create(:group, enterprise: user.enterprise) }
    let(:news_link) { create(:news_link, :group => group)}
    
    login_user_from_let

    describe 'GET #index' do
        it 'return success' do
            get :index, group_id: group.id
            expect(response).to be_success
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
            allow(UserGroupInstantNotificationJob).to receive(:perform_later)
            request.env["HTTP_REFERER"] = "back"
            patch :approve, group_id: group.id, link_id: news_link.news_feed_link.id
        end
        
        it 'return success' do
            expect(response).to redirect_to "back"
        end
        
        
        it "send group notification to users" do
            expect(UserGroupInstantNotificationJob).to have_received(:perform_later).with(group, news_count: 1).at_least(:once)
        end
    end
end
