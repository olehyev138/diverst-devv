require 'rails_helper'

RSpec.describe 'User', type: :request do
  let!(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise, password: 'password') }
  let(:another_user) { create(:user, enterprise: enterprise, password: 'password') }
  let(:basic_authentication) { ActionController::HttpAuthentication::Basic.encode_credentials(user.email, 'password') }
  let(:headers) { { 'HTTP_AUTHORIZATION' => basic_authentication } }

  it 'gets all users' do
    get '/api/v1/users', headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'gets a user' do
    get "/api/v1/users/#{user.id}", headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'creates a user' do
    new_user = { email: 'test@gmail.com', password: 'password', first_name: 'First', last_name: 'Last' }
    post '/api/v1/users', user: new_user, headers: headers
    expect(response).to have_http_status(201)
  end

  it 'updates a user' do
    patch "/api/v1/users/#{user.id}", user: { first_name: 'updated' }, headers: headers
    expect(response).to have_http_status(:ok)
  end

  it 'deletes a user' do
    delete "/api/v1/users/#{another_user.id}", headers: headers
    expect(response).to have_http_status(:no_content)
  end
end
