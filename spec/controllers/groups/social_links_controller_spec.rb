require 'rails_helper'

RSpec.describe Groups::SocialLinksController, type: :controller do
    let(:user) { create :user }
    let(:group){ create(:group, enterprise: user.enterprise) }
    
    login_user_from_let

    describe 'GET #new' do
        def get_new(group_id)
            get :new, group_id: group_id
        end
        
        context 'with logged user' do
            login_user_from_let

            before { get_new(group.to_param) }

            it 'return success' do
                expect(response).to be_success
            end
        end
    end

    describe 'POST#create' do
        before :each do
            post :create, group_id: group.id, social_link: attributes_for(:social_link)
        end
        
        it "redirect back" do
            expect(response).to redirect_to group_posts_path(group)
        end
    end

    describe 'DELETE#destroy' do
        let!(:social_link){ create(:social_link, group: group) }
        
        before :each do
            delete :destroy, group_id: group.id, id: social_link.id
        end
        
        it "redirects back" do
            expect(response).to redirect_to group_posts_path(group)
        end
    end
end
