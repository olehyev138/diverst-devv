require 'rails_helper'

RSpec.describe User::CampaignsController, type: :controller do
  let!(:published_campaign){ create(:campaign, status: Campaign.statuses[:published]) }
  let!(:draft_campaign){ create(:campaign, status: Campaign.statuses[:draft]) }
  let!(:user) { create :user, campaigns: [published_campaign, draft_campaign] }

  describe 'GET #index' do
    context 'with logged user' do
      login_user_from_let

      it 'assign to campaigns only published campaigns' do
        get :index
        expect(assigns(:campaigns)).to match_array [published_campaign]
      end
    end
  end
end
