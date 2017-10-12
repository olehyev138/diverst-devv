require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    include ActiveJob::TestHelper
    
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
            # ensure the job is performed and that
            # we don't receive any errors
            perform_enqueued_jobs do
                allow(UserGroupInstantNotificationJob).to receive(:perform_later).and_call_original
                request.env["HTTP_REFERER"] = "back"
                patch :approve, group_id: group.id, link_id: news_link.news_feed_link.id
            end
        end
        
        it 'return success' do
            expect(response).to redirect_to "back"
        end

        it "send group notification to users" do
            expect(UserGroupInstantNotificationJob).to have_received(:perform_later).with(group, news_count: 1).at_least(:once)
        end
    end
end
