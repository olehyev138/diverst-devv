require 'rails_helper'

RSpec.describe "User::QuestionsController", type: :controller do
    let(:user) { create :user}
    let(:campaign){ create(:campaign, enterprise: user.enterprise) }
	let(:question){ create(:question, campaign: campaign) }
    
    def setup
        @controller = User::QuestionsController.new
    end
    
    before {setup}
    
    login_user_from_let
    
    describe 'GET #index' do
        it "returns success" do
            get :index, user_campaign_id: campaign.id
            expect(response).to be_success
        end
    end
    
    describe 'GET #show' do
        it "returns success" do
            get :show, id: question.id
            expect(response).to be_success
        end
    end
end
