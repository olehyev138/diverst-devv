require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller, :focus => true do

  let(:api_key) { FactoryBot.create(:api_key) }
  let(:enterprise) { FactoryBot.create(:enterprise) }
  let(:user) { FactoryBot.create(:user, enterprise: enterprise) }
  let(:group) { FactoryBot.create(:group, enterprise: enterprise) }
  let(:item) { FactoryBot.create(:campaign) }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }

  before :each do
    request.headers.merge!(valid_session) # Add to request headers
  end

  describe 'GET #index' do
    context 'gets the items' do
      before do
        get :index, params: {}
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'creates an item' do
      before do
        group = create(:group)
        payload = {
            description: "The best campaign",
            start: Date.today,
            end: Date.tomorrow,
            title: "Link to Apple",
            enterprise_id: enterprise.id,
            group_ids: [group.id]
        }
        post :create, params: { campaign: payload }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'updates an item' do
      before do
        put :update, params: { id: item.id, campaign: { title: "updated" } }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'deletes an item' do
      before do
        delete :destroy, params: { id: item.id }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
