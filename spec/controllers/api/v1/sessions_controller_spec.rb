require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:api_key) { FactoryGirl.create(:api_key) }
  let(:user) { FactoryGirl.create(:user) }
  let(:jwt) { UserTokenService.create_jwt(user) }

  let(:valid_session) { { 'Diverst-APIKey' => api_key.key } }

  before :each do
    allow(File).to receive(:read).and_call_original
    request.headers.merge!(valid_session) # Add to request headers
  end

  describe 'POST #create' do
    context 'signs the user in' do
      before do
        signin = {
            email: user.email,
            password: user.password
        }
        post :create, params: signin
      end
      it 'responds with success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'signs the user out' do
      before do
        signin = {
            email: user.email,
            password: user.password
        }
        post :create, params: signin
      end
      it 'responds with success' do
        test_response = JSON.parse(response.body)
        valid_session['Diverst-UserToken'] = test_response['token']
        request.headers.merge!(valid_session) # Add to request headers again
        signout = User.find(user.id)
        delete :destroy, params: { id: signout.sessions.last.token }

        expect(response).to have_http_status(:success)
      end
    end

    context 'when session is missing' do
      before do
        signin = {
              email: user.email,
              password: user.password
          }
        post :create, params: signin
      end

      it 'responds with error' do
        test_response = JSON.parse(response.body)
        valid_session['Diverst-UserToken'] = test_response['token']
        request.headers.merge!(valid_session) # Add to request headers again
        signout = User.find(user.id)
        delete :destroy, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
