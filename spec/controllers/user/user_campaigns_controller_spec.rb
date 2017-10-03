require 'rails_helper'
require 'spec_helper'

RSpec.describe "User::UserCampaignsController", type: :controller do
    let!(:user) { create :user}
    let!(:published_campaign){ create(:campaign, status: Campaign.statuses[:published], enterprise: user.enterprise, owner: user) }
    let!(:draft_campaign){ create(:campaign, status: Campaign.statuses[:draft], enterprise: user.enterprise, owner: user) }
    let!(:campaign_invitation) { create(:campaign_invitation, :campaign => published_campaign, :user => user)}
    
    def setup
        @controller = User::UserCampaignsController.new
    end

    before {setup}

    describe 'GET #index' do
        context 'with logged user' do
            login_user_from_let
            
            before {get :index}
            
            it 'assign to campaigns only published campaigns' do
                expect(assigns(:campaigns)).to match_array [published_campaign]
            end
            
            it 'returns success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'GET #show', :skip => "Missing Template" do
        context 'with logged user' do
            login_user_from_let
            
            before {get :show, id: published_campaign.id}
            
            it 'returns success' do
                expect(response).to be_success
            end
        end
    end
    
    describe 'PATCH #update' do
        context 'with logged user' do
            login_user_from_let
            
            before {patch :update, id: published_campaign.id, campaign: {title: "test"}}
            
            it 'redirects' do
                expect(response).to redirect_to(published_campaign)
            end
            
            it 'flashes' do
                expect(flash[:notice]).to eq("Your campaign was updated")
            end
            
            it 'updates' do
                published_campaign.reload
                expect(published_campaign.title).to eq("test")
            end
        end
    end
    
    describe 'DELETE #destroy' do
        context 'with logged user' do
            login_user_from_let
            
            before {delete :destroy, id: published_campaign.id}
            
            it 'redirects' do
                expect(response).to redirect_to action: :index
            end

            it 'deletes' do
                expect(Campaign.where(:id => published_campaign.id).count).to eq(0)
            end
        end
    end
end
