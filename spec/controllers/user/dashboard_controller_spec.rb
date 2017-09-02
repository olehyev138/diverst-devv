require 'rails_helper'

RSpec.describe User::DashboardController, type: :controller do
    let(:user) { create :user }
    
    login_user_from_let
    
    describe 'GET #home' do
        it "returns success" do
            get :home
            expect(response).to be_success
        end
    end
    
    describe 'GET #rewards' do
        it "returns success" do
            get :rewards
            expect(response).to be_success
        end
    end
end
