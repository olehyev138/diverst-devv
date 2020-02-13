require 'rails_helper'
require 'spec_helper'

RSpec.describe User::UserCampaignsController, type: :controller do
  let!(:user) { create :user }
  let!(:published_campaign) { create(:campaign, status: Campaign.statuses[:published], enterprise: user.enterprise, owner: user) }
  let!(:draft_campaign) { create(:campaign, status: Campaign.statuses[:draft], enterprise: user.enterprise, owner: user) }
  let!(:campaign_invitation) { create(:campaign_invitation, campaign: published_campaign, user: user) }

  describe 'GET #index' do
    context 'with logged user' do
      let!(:published_campaign1) { create(:campaign, status: Campaign.statuses[:published], enterprise: user.enterprise, owner: user, created_at: Time.now - 1.hours, updated_at: Time.now - 1.hours) }
      let!(:campaign_invitation1) { create(:campaign_invitation, campaign: published_campaign1, user: user) }
      login_user_from_let

      before { get :index }

      it 'assign to campaigns only published campaigns' do
        expect(assigns(:campaigns)).to match_array [published_campaign, published_campaign1]
      end

      it 'render index template' do
        expect(response).to render_template :index
      end
    end

    context 'without a logged in user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  # MISSING TEMPLATE for show action

  describe 'PATCH #update' do
    describe 'with logged user' do
      login_user_from_let

      context 'successful update' do
        before { patch :update, id: published_campaign.id, campaign: { title: 'test' } }

        it 'redirects to campaign' do
          expect(response).to redirect_to(published_campaign)
        end

        it 'flashes a notice message' do
          expect(flash[:notice]).to eq('Your campaign was updated')
        end

        it 'updates the campaign' do
          published_campaign.reload
          expect(assigns[:campaign].title).to eq('test')
        end
      end
    end

    describe 'with user not logged in' do
      before { patch :update, id: published_campaign.id, campaign: { title: 'test' } }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end


  describe 'DELETE #destroy' do
    context 'with logged user' do
      login_user_from_let

      it 'redirects to index action' do
        delete :destroy, id: published_campaign.id
        expect(response).to redirect_to action: :index
      end

      it 'deletes campaign object' do
        expect { delete :destroy, id: published_campaign.id }
        .to change(Campaign, :count).by(-1)
      end
    end

    context 'with user not logged in' do
      before { delete :destroy, id: published_campaign.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
