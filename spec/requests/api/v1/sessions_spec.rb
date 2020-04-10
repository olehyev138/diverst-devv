require 'rails_helper'

model = 'Session'
RSpec.describe "#{model.pluralize}", type: :request do
  let(:api_key) { FactoryBot.create(:api_key) }
  let(:jwt) { UserTokenService.create_jwt(user) }

  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key } }

  describe '#create' do
    it 'creates the session' do
      create(:user, email: 'signin@diverst.com', password: 'password', password_confirmation: 'password')

      user = {
        email: 'signin@diverst.com',
        password: 'password',
      }

      post '/api/v1/sessions', params: user, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it 'captures the error' do
      allow(User).to receive(:signin).and_raise(BadRequestException)
      create(:user, email: 'signin@diverst.com', password: 'password', password_confirmation: 'password')

      user = {
        email: 'signin@diverst.com',
        password: 'password',
      }

      post '/api/v1/sessions', params: user, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe '#logout' do
    it 'logout' do
      create(:user, email: 'signin@diverst.com', password: 'password', password_confirmation: 'password')

      signin = {
        email: 'signin@diverst.com',
        password: 'password',
      }
      post '/api/v1/sessions', params: signin, headers: headers
      expect(response).to have_http_status(:ok)
      test_response = JSON.parse(response.body)

      headers['Diverst-UserToken'] = test_response['token']

      delete '/api/v1/sessions/logout', params: nil, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it 'captures bad request if the token is undecodable' do
      # allow(model.constantize).to receive(:logout).and_raise(BadRequestException)
      # Not needed as the request returns unauthorized during initial JWT verification if the JWT is invalid
      create(:user, email: 'signin@diverst.com', password: 'password', password_confirmation: 'password')

      signin = {
        email: 'signin@diverst.com',
        password: 'password',
      }
      post '/api/v1/sessions', params: signin, headers: headers
      expect(response).to have_http_status(:ok)

      headers['Diverst-UserToken'] = 'iamnotavalidtoken'

      delete '/api/v1/sessions/logout', params: nil, headers: headers
      expect(response).to have_http_status(:bad_request)
    end
  end
end
