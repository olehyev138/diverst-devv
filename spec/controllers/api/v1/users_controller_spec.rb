require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:api_key) { FactoryGirl.create(:api_key) }
  let(:enterprise) { FactoryGirl.create(:enterprise) }
  let(:user) { FactoryGirl.create(:user, enterprise: enterprise) }
  let(:jwt) { UserTokenService.create_jwt(user) }
  let(:valid_session) { { 'Diverst-APIKey' => api_key.key, 'Diverst-UserToken' => jwt } }

  before :each do
    request.headers.merge!(valid_session) # Add to request headers
  end

  describe 'GET #index' do
    context 'gets the users' do
      before do
        get :index, params: {}
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    context 'creates a user' do
      before do
        password = Faker::Internet.password
        payload = {
            first_name: 'Bob',
            last_name: 'Smith',
            email: Faker::Internet.email,
            password: password,
            password_confirmation: password,
            enterprise_id: enterprise.id
        }
        post :create, params: { user: payload }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT #update' do
    context 'updates a user' do
      before do
        put :update, params: { id: user.id, user: { last_name: 'last_name' } }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'deletes a user' do
      before do
        delete :destroy, params: { id: user.id }
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
