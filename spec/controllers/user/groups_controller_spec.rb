require 'rails_helper'

RSpec.describe "User::GroupsController", type: :controller do
    let(:user) { create :user}
    let(:group){ create(:group, enterprise: user.enterprise) }
    
    def setup
        @controller = User::GroupsController.new
    end
    
    before {setup}
    
    login_user_from_let
    
    describe 'GET #index' do
        it "returns success" do
            get :index
            expect(response).to be_success
        end
    end
    
    describe 'GET #join' do
        it "returns success" do
            get :join, id: group.id
            expect(response).to be_success
        end
    end
end
