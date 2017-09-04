require 'rails_helper'

RSpec.describe User::EventsController, type: :controller do
    let(:user) { create :user}
    
    login_user_from_let
    
    describe 'GET #index' do
        it "returns success" do
            get :index
            expect(response).to be_success
        end
    end
    
    describe 'GET #calendar' do
        it "returns success" do
            get :calendar
            expect(response).to be_success
        end
    end
    
    describe 'GET #onboarding_calendar_data' do
        it "returns success" do
            user.invite!
            get :onboarding_calendar_data, invitation_token: user.raw_invitation_token, format: :json
            expect(response).to be_success
        end
    end
end
