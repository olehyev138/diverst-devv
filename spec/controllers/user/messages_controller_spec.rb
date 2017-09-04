require 'rails_helper'

RSpec.describe "User::MessagesController", type: :controller do
    let(:user) { create :user}
    
    def setup
        @controller = User::MessagesController.new
    end
    
    before {setup}
    
    login_user_from_let
    
    describe 'GET #index' do
        it "returns success" do
            get :index
            expect(response).to be_success
        end
    end
end
