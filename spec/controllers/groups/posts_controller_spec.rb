require 'rails_helper'

RSpec.describe Groups::PostsController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    
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
        it 'return success' do
            request.env["HTTP_REFERER"] = "back"
            news_link = create(:news_link, :group => group)
            patch :approve, group_id: group.id, link_id: news_link.news_feed_link.id
            expect(response).to redirect_to "back"
        end
    end
end
