require 'rails_helper'

RSpec.describe Api::V1::ResourcesController, type: :controller do

  let(:api_key) { FactoryBot.create(:api_key) }
  let(:enterprise) { FactoryBot.create(:enterprise) }
  let(:user) { FactoryBot.create(:user, enterprise: enterprise) }
  let(:group) { FactoryBot.create(:group, enterprise: enterprise) }
  let(:item) { FactoryBot.create(:resource) }
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
        folder = create(:folder)
        payload = {
            url: "www.apple.com",
            title: "Link to Apple",
            folder_id: folder.id
        }
        post :create, params: { resource: payload }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'updates an item' do
      before do
        put :update, params: { id: item.id, resource: { url: "www.apple.com" } }
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
