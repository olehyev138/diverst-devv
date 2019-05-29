require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do
  let(:api_key) { FactoryGirl.create(:api_key) }
  let(:enterprise) { FactoryGirl.create(:enterprise) }
  let(:user) { FactoryGirl.create(:user, enterprise: enterprise) }
  let(:group) { FactoryGirl.create(:group, enterprise: enterprise) }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }

  before :each do
    request.headers.merge!(valid_session) # Add to request headers
  end

  describe 'GET #index' do
    context 'gets the groups' do
      before do
        get :index, params: {}
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'creates a group' do
      before do
        payload = {
            name: 'Test, Inc'
        }
        post :create, params: { group: payload }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'updates a group' do
      before do
        put :update, params: { id: group.id, group: { name: 'name' } }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'deletes a group' do
      before do
        delete :destroy, params: { id: group.id }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
