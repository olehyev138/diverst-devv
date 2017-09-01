require 'rails_helper'

RSpec.describe Polls::GraphsController, type: :controller do
    
    let(:user) { create :user }
    let(:poll){ create(:poll, enterprise: user.enterprise) }

    login_user_from_let
    
    describe 'GET#new' do
        it "returns success" do
            get :new, poll_id: poll.id
            expect(response).to be_success
        end
    end
    
    describe 'POST#create' do
        it "redirects" do
            post :create, poll_id: poll.id, graph: {field_id: 1}
            expect(response).to redirect_to(poll)
        end
    end
end
