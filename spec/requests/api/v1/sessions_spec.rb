require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:api_key) { FactoryGirl.create(:api_key) }
  let(:jwt) { UserTokenService.create_jwt(user) }

  let(:headers) { { 'HTTP_DIVERST_APIKEY' => api_key.key } }

  it 'signin' do
    create(:user, email: 'signin@diverst.com', password: 'password', password_confirmation: 'password')

    user = {
      email: 'signin@diverst.com',
      password: 'password',
    }

    post '/api/v1/sessions', params: user, headers: headers

    expect(response).to have_http_status(:ok)
  end

  it 'destroy' do
    user = create(:user, email: 'signin@diverst.com', password: 'password', password_confirmation: 'password')

    signin = {
      email: 'signin@diverst.com',
      password: 'password',
    }
    post '/api/v1/sessions', params: signin, headers: headers
    expect(response).to have_http_status(:ok)
    test_response = JSON.parse(response.body)

    headers['Diverst-UserToken'] = test_response['token']
    user = User.find(user.id)

    delete "/api/v1/sessions/#{user.sessions.last.token}", params: nil, headers: headers

    expect(response).to have_http_status(:ok)
  end
end
